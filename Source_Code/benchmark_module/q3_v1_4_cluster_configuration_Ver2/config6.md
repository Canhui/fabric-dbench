## 2. Nodejs多方背书

#### 2.1. 多方背书环境

多方背书的chaincode: demo3

多方背书的组织: ubuntu00, ubuntu01


#### 2.2. 多方背书的invoke代码实现(ubuntu00端,单点)

```js
'use strict';

var hfc = require('fabric-client'); 
var path = require('path'); 
var util = require('util'); 
var sdkUtils = require('fabric-client/lib/utils') 
const fs = require('fs'); 
var channel = {}; 
var client = null; 
var targets = []; 
var tx_id = null; 
var start_counter;
var end_counter;

var options1 = { 
    user_id: 'Admin@org1.example.com', 
    msp_id:'Org1MSP', 
    channel_id: 'mychannel', 
    chaincode_id: 'demo', 
    peer_url: 'grpcs://localhost:7051',//因为启用了TLS，所以是grpcs,如果没有启用TLS，那么就是grpc 
    event_url: 'grpcs://localhost:7053',//因为启用了TLS，所以是grpcs,如果没有启用TLS，那么就是grpc 
    orderer_url: 'grpcs://localhost:7050',//因为启用了TLS，所以是grpcs,如果没有启用TLS，那么就是grpc 
    privateKeyFolder:'/home/joe/fabric-samples/Admin@org1.example.com/msp/keystore', 
    signedCert:'/home/joe/fabric-samples/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem', 
    peer_tls_cacerts:'/home/joe/fabric-samples/peer0.org1.example.com/tls/ca.crt', 
    orderer_tls_cacerts:'/home/joe/fabric-samples/orderer.example.com/tls/ca.crt', 
    server_hostname: "peer0.org1.example.com" 
};

const getKeyFilesInDir = (dir) => { 
//该函数用于找到keystore目录下的私钥文件的路径 
        const files = fs.readdirSync(dir) 
        const keyFiles = [] 
        files.forEach((file_name) => { 
                let filePath = path.join(dir, file_name) 
                if (file_name.endsWith('_sk')) { 
                        keyFiles.push(filePath) 
                } 
        }) 
        return keyFiles 
}

Promise.resolve().then(() => {
//    console.log("Load_privateKey_and_signedCert: %j", Date.now()/1000); 
    client = new hfc(); // One client is enough
    var    createUserOpt1 = { 
                username: options1.user_id, 
                mspid: options1.msp_id, 
                cryptoContent: { privateKey: getKeyFilesInDir(options1.privateKeyFolder)[0], 
  signedCert: options1.signedCert } 
}

//以上代码指定了当前用户的私钥，证书等基本信息 
return sdkUtils.newKeyValueStore({ 
                        path: "/tmp/fabric-client-stateStore/" 
                }).then((store) => { 
                        client.setStateStore(store) 
                        return client.createUser(createUserOpt1) 
                }) 
}).then((user) => { 
    channel = client.newChannel(options1.channel_id); // <-one channel
    let data1 = fs.readFileSync(options1.peer_tls_cacerts); // <- two data
    let peer1 = client.newPeer(options1.peer_url, // <- two peer
        { 
            pem: Buffer.from(data1).toString(), 
            'ssl-target-name-override': options1.server_hostname 
        } 
    ); 

    //因为启用了TLS，所以上面的代码就是指定Peer的TLS的CA证书 
    channel.addPeer(peer1); // one channel, two peers

    //接下来连接Orderer的时候也启用了TLS，也是同样的处理方法 
    let odata = fs.readFileSync(options1.orderer_tls_cacerts); 
    let caroots = Buffer.from(odata).toString(); 
    var orderer = client.newOrderer(options1.orderer_url, { 
        'pem': caroots, 
        'ssl-target-name-override': "orderer.example.com" 
    }); 

    channel.addOrderer(orderer); // <- one orderer
    targets.push(peer1); // <- two peers
    return;
}).then(() => {
    // --------------transactions below-----------------------
    tx_id = client.newTransactionID(); 

    function makeid(length) {
       var result           = '';
       var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
       var charactersLength = characters.length;
       for ( var i = 0; i < length; i++ ) {
            result += characters.charAt(Math.floor(Math.random() * charactersLength));
       }
        return result;
    }

    var request = { 
        targets: targets, 
        chaincodeId: options1.chaincode_id, 
        fcn: 'write', 
        args: ['key1','a'],
        //args: ['k', makeid(30*1000*1000)], // 1000 * 1000 = 1M
        chainId: options1.channel_id, 
        txId: tx_id 
    }; 

    return channel.sendTransactionProposal(request); 
}).then((results) => { 
    var proposalResponses = results[0]; 
    var proposal = results[1]; 
    var header = results[2]; 
    // let isProposalGood = false;
    var all_good = true;
    for(var i in proposalResponses){
        let one_good = false;
        //检验提案响应信息是否正确
        if(proposalResponses && proposalResponses[0].response && proposalResponses[0].response.status === 200){
            one_good = true;
            console.info('transaction proposal was good');
        }else{
            console.error('transaction proposal was bad');
        }
        all_good = all_good & one_good;
    }

    if (all_good) {
        var request = {
            proposalResponses: proposalResponses,
            proposal: proposal
        };
        var transaction_id_string = tx_id.getTransactionID(); //Get the transaction ID string to be used by the event processing
        var promises = [];
        var sendPromise = channel.sendTransaction(request);
//        console.log('p3_start: %j', Date.now()/1000);
        start_counter = Date.now()/1000;
        promises.push(sendPromise); //we want the send transaction first, so that we know where to check status     
        let event_hub = channel.newChannelEventHub('localhost:7051');
        //接下来设置EventHub，用于监听Transaction是否成功写入，这里也是启用了TLS 
        let data = fs.readFileSync(options1.peer_tls_cacerts);
        let grpcOpts = {
             pem: Buffer.from(data).toString(),
            'ssl-target-name-override': options1.server_hostname
        }
        let txPromise = new Promise((resolve, reject) => {
            let handle = setTimeout(() => {
                event_hub.disconnect();
                resolve({event_status : 'TIMEOUT'}); //we could use reject(new Error('Trnasaction did not complete within 30 seconds'));
            }, 3000);
            event_hub.connect();
            event_hub.registerTxEvent(transaction_id_string, (tx, code) => {
                // this is the callback for transaction event status
                // first some clean up of event listener
                clearTimeout(handle);
                event_hub.unregisterTxEvent(transaction_id_string);
                event_hub.disconnect();
                var return_status = {event_status : code, tx_id : transaction_id_string};
                if (code !== 'VALID') {
                    console.error('transaction_invalid: %j', Date.now()/1000);
                    resolve(return_status); // we could use reject(new Error('Problem with the tranaction, event status ::'+code));
                } else {
                    resolve(return_status);
                }
            }, (err) => {
                //this is the callback if something goes wrong with the event registration or processing
                reject(new Error('problem_with_the_eventhub'));
            });
        });
        promises.push(txPromise);

        return Promise.all(promises);
    } else {
        //console.error([Date.now()/1000],'Failed to send Proposal or receive valid response. Response null or status is not 200. exiting...');
        throw new Error('Failed to send Proposal or receive valid response. Response null or status is not 200. exiting...');
    } 
}).then((results) => {
    var end_counter = Date.now()/1000;
    console.log(end_counter-start_counter+','+ Date.now()/1000)
    if (results && results[0] && results[0].status === 'SUCCESS') {
//        console.log('transaction_sent_to_orderer: %j', Date.now()/1000);
    } else {
        console.error('Failed to order the transaction. Error code: ' + response.status);
    }

    if(results && results[1] && results[1].event_status === 'VALID') {
        console.log('transaction_committed_the_change_to_the_ledger_of_the_peer: %j', Date.now()/1000);
    } else {
        console.log('Transaction failed to be committed to the ledger due to ::'+results[1].event_status);
    }
}).catch((err) => {
    console.error('Failed to invoke successfully :: ' + err);
});
```


## 参考资料
[1. 多方背书] https://blog.csdn.net/ASN_forever/article/details/89024550