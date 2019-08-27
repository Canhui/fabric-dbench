Orderer机器上运行nodejs测试项目。


## 1. 新建目录

新建nodeTest工作目录如下，

```shell
~/fabric-samples$ mkdir nodeTest
```

<br />
<br />



## 2. 新建配置文件package.json

在nodeTest工作目录下，新建配置文件package.json，内容如下，

```json
{
    "name": "nodeTest",
    "version": "1.0.0",
    "description": "Hyperledger Fabric Node SDK Test Application",
    "scripts": {
        "test": "echo \"Error: no test specified\" && exit 1"
    },
    "dependencies": {
        "fabric-ca-client": "^1.0.0",
        "fabric-client": "^1.0.0"
    },
    "author": "Devin Zeng",
    "license": "Apache-2.0",
    "keywords": [
        "Hyperledger",
        "Fabric",
        "Test",
        "Application"
    ]
}
```


编译安装配置依赖项，命令如下，
```shell
~/fabric-samples/nodeTest$ npm install
```


<br />
<br />

## 3. 新建查询文件query.js

新建query.js查询文件，内容如下，

```js
var hfc = require('fabric-client');
var path = require('path');
var sdkUtils = require('fabric-client/lib/utils');
var fs = require('fs');
var options = {
    user_id:'Admin@org1.example.com',
    msp_id:'Org1MSP',
    channel_id:'mychannel',
    chaincode_id:'demo',
    network_url:'grpcs://localhost:7051',
    privateKeyFolder:'/home/joe/fabric-samples/Admin@org1.example.com/msp/keystore',
    signedCert:'/home/joe/fabric-samples/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem',
    tls_cacerts:'/home/joe/fabric-samples/peer0.org1.example.com/tls/ca.crt',
    server_hostname:'peer0.org1.example.com'
};

var channel = {};
var client = null;
const getKeyFilesInDir = function(dir) {
    var files = fs.readdirSync(dir);
    var keyFiles = [];
    files.forEach(function(file_name) {
        filePath = path.join(dir, file_name);
        if (file_name.endsWith('_sk')) {
            keyFiles.push(filePath);
        }
    });
    return keyFiles;
};

Promise.resolve().then(function() {
    console.log('Load privateKey and signedCert');
    client = new hfc();
    var createUserOpt = {
        username:options.user_id,
        mspid:options.msp_id,
        cryptoContent:{privateKey:getKeyFilesInDir(options.privateKeyFolder)[0], signedCert:options.signedCert}
    };

    return sdkUtils.newKeyValueStore({path:'/tmp/fabric-client-stateStore/'})
    .then(function(store) {
        client.setStateStore(store);
        return client.createUser(createUserOpt);
    });
}).then(function(user) {
    channel = client.newChannel(options.channel_id);
    data = fs.readFileSync(options.tls_cacerts);
    peer = client.newPeer(options.network_url, {
        pem:Buffer.from(data).toString(),
        'ssl-target-name-override':options.server_hostname
    });
    peer.setName('peer-a');
    channel.addPeer(peer);
    return;
}).then(function() {
    console.log('Make query');
    var transaction_id = client.newTransactionID();
    console.log('Assigning transaction_id: ', transaction_id._transaction_id);

    const request = {
        chaincodeId:options.chaincode_id,
        txId:transaction_id,
        fcn:'query',
        args:['key1']
    };
    return channel.queryByChaincode(request);
}).then(function(query_responses) {
    console.log('returned from query');
    if (!query_responses.length) {
        console.log('No payloads were returned from query');
    } else {
        console.log('Query result count = ', query_responses.length);
    }

    if (query_responses[0] instanceof Error) {
        console.log('error from query = ', query_responses[0]);
    }
    console.log('Response is ', query_responses[0].toString());
}).catch(function(err) {
    console.error('Caught Error', err);
});
```

测试查询结果，命令如下，
```shell
~/fabric-samples/nodeTest$ node query.js
Load privateKey and signedCert
Make query
Assigning transaction_id:  516738f9959c522fceff7c27a4e76974edba1531bdc97603012d7583b3241785
returned from query
Query result count =  1
Response is  a
```

<br />
<br />


## 4. 新建写入文件invoke.js

写入文件invoke.js，内容如下，

```js
'use strict';

var hfc = require('fabric-client'); 
var path = require('path'); 
var util = require('util'); 
var sdkUtils = require('fabric-client/lib/utils') 
const fs = require('fs'); 
var options = { 
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

var channel = {}; 
var client = null; 
var targets = []; 
var tx_id = null; 
var start_counter;
var end_counter;


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
    client = new hfc(); 
    var    createUserOpt = { 
                username: options.user_id, 
                mspid: options.msp_id, 
                cryptoContent: { privateKey: getKeyFilesInDir(options.privateKeyFolder)[0], 
  signedCert: options.signedCert } 
         } 

//以上代码指定了当前用户的私钥，证书等基本信息 
return sdkUtils.newKeyValueStore({ 
                        path: "/tmp/fabric-client-stateStore/" 
                }).then((store) => { 
                        client.setStateStore(store) 
                        return client.createUser(createUserOpt) 
                }) 
}).then((user) => { 
    channel = client.newChannel(options.channel_id); 
    let data = fs.readFileSync(options.peer_tls_cacerts); 
    let peer = client.newPeer(options.peer_url, 
        { 
            pem: Buffer.from(data).toString(), 
            'ssl-target-name-override': options.server_hostname 
        } 
    ); 
    //因为启用了TLS，所以上面的代码就是指定Peer的TLS的CA证书 
    channel.addPeer(peer); 
    
    //接下来连接Orderer的时候也启用了TLS，也是同样的处理方法 
    let odata = fs.readFileSync(options.orderer_tls_cacerts); 
    let caroots = Buffer.from(odata).toString(); 
    var orderer = client.newOrderer(options.orderer_url, { 
        'pem': caroots, 
        'ssl-target-name-override': "orderer.example.com" 
    }); 
    
    channel.addOrderer(orderer); 
    targets.push(peer); 
    return; 
}).then(() => { 
    
    // get a transaction id object based on the current user assigned to fabric client
    tx_id = client.newTransactionID(); 
    //console.log([Date.now()/1000],"Assigning_transaction_id: %j", tx_id._transaction_id);
//    console.log("Assigning_transaction_id: %j", Date.now()/1000);
//发起转账行为，将a->b 10元 

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
        chaincodeId: options.chaincode_id, 
        fcn: 'write', 
        args: ['key1','a'],
        //args: ['k', makeid(30*1000*1000)], // 1000 * 1000 = 1M
        chainId: options.channel_id, 
        txId: tx_id 
    }; 

    // send the transaction proposal to the peers
//    console.log('p1_start: %j', Date.now()/1000);
    return channel.sendTransactionProposal(request); 
}).then((results) => { 
    var proposalResponses = results[0]; 
    var proposal = results[1]; 
    var header = results[2]; 
    let isProposalGood = false; 
    if (proposalResponses && proposalResponses[0].response && 
        proposalResponses[0].response.status === 200) { 
        isProposalGood = true; 
//        console.log('transaction_proposal_was_good: %j', Date.now()/1000); 
    } else { 
        console.error('transaction_proposal_was_bad: %j', Date.now()/1000); 
    }
//    console.log('p1_end: %j', Date.now()/1000);
// -------------------------OLD Aug 13, 2019: 10:32 AM---------------------------- 
//    if (isProposalGood) { 
//        console.log(util.format( 
//            'Successfully sent Proposal and received ProposalResponse: Status - %s, message - "%s", metadata - "%s", endorsement signature: %s', 
//            proposalResponses[0].response.status, proposalResponses[0].response.message, 
//            proposalResponses[0].response.payload, proposalResponses[0].endorsement.signature));
// -------------------------NEW Aug 13, 2019: 10:32 AM----------------------------
    if (isProposalGood) {
//        console.log(util.format(
//            [Date.now()/1000],'Successfully sent Proposal and received ProposalResponse: Status - %s, message - "%s"',
//            proposalResponses[0].response.status, proposalResponses[0].response.message));


// -------------------------OLD Aug 13, 2019: 10:34 AM----------------------------
//        var request = { 
//            proposalResponses: proposalResponses, 
//             proposal: proposal, 
//            header: header 
//        }; 
// -------------------------NEW Aug 13, 2019: 10:34 AM----------------------------
        var request = {
            proposalResponses: proposalResponses,
            proposal: proposal
        };

         // set the transaction listener and set a timeout of 30sec 
        // if the transaction did not get committed within the timeout period, 
        // fail the test 
// -------------------------OLD Aug 13, 2019: 10:36 AM----------------------------
//        var transactionID = tx_id.getTransactionID(); 
//        var eventPromises = []; 
// -------------------------NEW Aug 13, 2019: 10:36 AM----------------------------
        var transaction_id_string = tx_id.getTransactionID(); //Get the transaction ID string to be used by the event processing
        var promises = [];
        var sendPromise = channel.sendTransaction(request);
//        console.log('p3_start: %j', Date.now()/1000);
        start_counter = Date.now()/1000;
        promises.push(sendPromise); //we want the send transaction first, so that we know where to check status     

// -------------------------OLD Aug 13, 2019: 10:38 AM----------------------------
//        let eh = client.newEventHub();
// -------------------------NEW Aug 13, 2019: 10:38 AM----------------------------
//        let event_hub = fabric_client.newEventHub();
//        event_hub.setPeerAddr('grpc://localhost:7053');
// -------------------------NEW v2 Aug 13, 2019: 10:38 AM----------------------------
        let event_hub = channel.newChannelEventHub('localhost:7051');



// -------------------------OLD Aug 13, 2019: 10:40 AM----------------------------  
//        //接下来设置EventHub，用于监听Transaction是否成功写入，这里也是启用了TLS 
//        let data = fs.readFileSync(options.peer_tls_cacerts); 
//        let grpcOpts = { 
//             pem: Buffer.from(data).toString(), 
//            'ssl-target-name-override': options.server_hostname 
//        } 
//        eh.setPeerAddr(options.event_url,grpcOpts); 
//        eh.connect();
// -------------------------NEW Aug 13, 2019: 10:38 AM----------------------------
        //接下来设置EventHub，用于监听Transaction是否成功写入，这里也是启用了TLS 
        let data = fs.readFileSync(options.peer_tls_cacerts);
        let grpcOpts = {
             pem: Buffer.from(data).toString(),
            'ssl-target-name-override': options.server_hostname
        }


// -------------------------OLD Aug 13, 2019: 10:44 AM----------------------------
//        let txPromise = new Promise((resolve, reject) => { 
//            let handle = setTimeout(() => { 
//                eh.disconnect(); 
//                reject(); 
//            }, 30000);
// -------------------------NEW Aug 13, 2019: 10:44 AM---------------------------- 
        let txPromise = new Promise((resolve, reject) => {
            let handle = setTimeout(() => {
                event_hub.disconnect();
                resolve({event_status : 'TIMEOUT'}); //we could use reject(new Error('Trnasaction did not complete within 30 seconds'));
            }, 3000);


// -------------------------OLD Aug 13, 2019: 10:45 AM----------------------------
//向EventHub注册事件的处理办法 
//            eh.registerTxEvent(transactionID, (tx, code) => { 
//                clearTimeout(handle); 
//                eh.unregisterTxEvent(transactionID); 
//                eh.disconnect();
// -------------------------NEW Aug 13, 2019: 10:45 AM----------------------------
            event_hub.connect();
            event_hub.registerTxEvent(transaction_id_string, (tx, code) => {
                // this is the callback for transaction event status
                // first some clean up of event listener
                clearTimeout(handle);
                event_hub.unregisterTxEvent(transaction_id_string);
                event_hub.disconnect();




// -------------------------OLD Aug 13, 2019: 10:46 AM----------------------------
//                if (code !== 'VALID') { 
//                    console.error( 
//                        'The transaction was invalid, code = ' + code); 
//                    reject(); 
//                 } else { 
// -------------------------NEW Aug 13, 2019: 10:46 AM----------------------------
                var return_status = {event_status : code, tx_id : transaction_id_string};
                if (code !== 'VALID') {
                    console.error('transaction_invalid: %j', Date.now()/1000);
                    resolve(return_status); // we could use reject(new Error('Problem with the tranaction, event status ::'+code));
                } else {



// -------------------------OLD Aug 13, 2019: 10:48 AM----------------------------
//                    //console.log(                                                              //OLD: Aug 13, 2019: 10:03AM
//                    //     'The transaction has been committed on peer '
//                    //     + 
//                    //     eh._ep._endpoint.addr); 
//                    console.log('The transaction has been committed on peer'+eh.getPeerAddr()); // NEW: Aug 13, 2019: 10:03AM
//                    resolve(); 
//                } 
//            }); 
//        });
// -------------------------NEW Aug 13, 2019: 10:48 AM----------------------------
                    //console.log('The transaction has been committed on peer ' + event_hub._ep._endpoint.addr);
//                    console.log('transaction_committed_on_peer: %j', Date.now()/1000);
                    resolve(return_status);
                }
            }, (err) => {
                //this is the callback if something goes wrong with the event registration or processing
                reject(new Error('problem_with_the_eventhub'));
            });
        });


// -------------------------OLD Aug 13, 2019: 10:50 AM---------------------------- 
//        eventPromises.push(txPromise); 
//        var sendPromise = channel.sendTransaction(request); 
//        return Promise.all([sendPromise].concat(eventPromises)).then((results) => { 
//            console.log(' event promise all complete and testing complete'); 
//             return results[0]; // the first returned value is from the 'sendPromise' which is from the 'sendTransaction()' call 
//        }).catch((err) => { 
//            console.error( 
//                'Failed to send transaction and get notifications within the timeout period.' 
//            ); 
//            return 'Failed to send transaction and get notifications within the timeout period.'; 
//         }); 
//    } else { 
//        console.error( 
//            'Failed to send Proposal or receive valid response. Response null or status is not 200. exiting...' 
//        ); 
//        return 'Failed to send Proposal or receive valid response. Response null or status is not 200. exiting...'; 
//    } 
//}, (err) => { 
//    console.error('Failed to send proposal due to error: ' + err.stack ? err.stack : 
//        err); 
//    return 'Failed to send proposal due to error: ' + err.stack ? err.stack : 
//        err;
// -------------------------NEW Aug 13, 2019: 10:50 AM----------------------------
        promises.push(txPromise);

        return Promise.all(promises);
    } else {
        //console.error([Date.now()/1000],'Failed to send Proposal or receive valid response. Response null or status is not 200. exiting...');
        throw new Error('Failed to send Proposal or receive valid response. Response null or status is not 200. exiting...');
    } 

// -------------------------OLD Aug 13, 2019: 10:52 AM----------------------------
//}).then((response) => { 
//    if (response.status === 'SUCCESS') { 
//        console.log('Successfully sent transaction to the orderer.'); 
//        return tx_id.getTransactionID(); 
//    } else { 
//        console.error('Failed to order the transaction. Error code: ' + response.status); 
//        return 'Failed to order the transaction. Error code: ' + response.status; 
//    } 
//}, (err) => { 
//    console.error('Failed to send transaction due to error: ' + err.stack ? err 
//         .stack : err); 
//    return 'Failed to send transaction due to error: ' + err.stack ? err.stack : 
//        err; 
//});

// -------------------------NEW Aug 13, 2019: 10:52 AM----------------------------
}).then((results) => {
    var end_counter = Date.now()/1000;
    console.log(end_counter-start_counter+','+ Date.now()/1000)
//    console.log('{"delay": "%j",', end_counter-start_counter);
//    console.log('"p4_end": "%j"}', Date.now()/1000);
//    console.log('p5_start: %j', Date.now()/1000);
    //console.log([Date.now()/1000],'Send transaction promise and event listener promise have completed');
    // check the results in the order the promises were added to the promise all list
    if (results && results[0] && results[0].status === 'SUCCESS') {
//        console.log('transaction_sent_to_orderer: %j', Date.now()/1000);
    } else {
        console.error('Failed to order the transaction. Error code: ' + response.status);
    }

    if(results && results[1] && results[1].event_status === 'VALID') {
//        console.log('transaction_committed_the_change_to_the_ledger_of_the_peer: %j', Date.now()/1000);
//        console.log('p5_end: %j', Date.now()/1000);
    } else {
        console.log('Transaction failed to be committed to the ledger due to ::'+results[1].event_status);
    }
}).catch((err) => {
    console.error('Failed to invoke successfully :: ' + err);
});
```