ORGS=3
chaincode_name="demo"
channel_name="mychannel"
key="key1"
value="value1"


echo "------------------------------------------------------------"
echo "Clean the Invoke Environment"
echo "------------------------------------------------------------"
rm -rf /home/t716/fabric-dbench/fabric-samples/sdk.org*.example.com/invoke_or_*.js



echo "------------------------------------------------------------"
echo "Each Org Creates Invoke Function under Endorsement Policy 'OR'"
echo "------------------------------------------------------------"
cat>/home/t716/fabric-dbench/fabric-samples/sdk.org1.example.com/invoke_or_individual.js<<EOF
'use strict';
var hfc = require('fabric-client'); 
var path = require('path'); 
var util = require('util'); 
var sdkUtils = require('fabric-client/lib/utils') 
const fs = require('fs'); 
var options = { 
    user_id: 'Admin@org1.example.com', 
    msp_id:'Org1MSP', 
    channel_id: '$channel_name', 
    chaincode_id: '$chaincode_name', 
    peer_url: 'grpcs://localhost:7051',// TLS->grpcs; no TLS->grpc 
    event_url: 'grpcs://localhost:7053',
    orderer_url: 'grpcs://orderer1.example.com:7050',
    privateKeyFolder:'/home/t716/fabric-dbench/fabric-samples/Admin@org1.example.com/msp/keystore', 
    signedCert:'/home/t716/fabric-dbench/fabric-samples/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem', 
    peer_tls_cacerts:'/home/t716/fabric-dbench/fabric-samples/peer0.org1.example.com/tls/ca.crt', 
    orderer_tls_cacerts:'/home/t716/fabric-dbench/fabric-samples/orderer1.example.com/tls/ca.crt', 
    server_hostname: "peer0.org1.example.com" 
};
var channel = {}; 
var client = null; 
var targets = []; 
var tx_id = null; 
var start_counter;
var end_counter;
// Functions to Get the private key files under the keystore directory
const getKeyFilesInDir = (dir) => { 
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
// Get the the private key files under the keystore directory
Promise.resolve().then(() => { 
    client = new hfc(); 
    var    createUserOpt = { 
                username: options.user_id, 
                mspid: options.msp_id, 
                cryptoContent: { privateKey: getKeyFilesInDir(options.privateKeyFolder)[0], 
  signedCert: options.signedCert } 
    } 
return sdkUtils.newKeyValueStore({ 
                        path: "/tmp/fabric-client-stateStore/" 
                }).then((store) => { 
                        client.setStateStore(store) 
                        return client.createUser(createUserOpt) 
                }) 
}).then((user) => { 
    // Handle the TLS files for a new Peer
    channel = client.newChannel(options.channel_id); 
    let data = fs.readFileSync(options.peer_tls_cacerts); 
    let peer = client.newPeer(options.peer_url, 
        { 
            pem: Buffer.from(data).toString(), 
            'ssl-target-name-override': options.server_hostname 
        } 
    ); 
    channel.addPeer(peer); 
    
    // Handle the TLS files for the orderer
    let odata = fs.readFileSync(options.orderer_tls_cacerts); 
    let caroots = Buffer.from(odata).toString(); 
    var orderer = client.newOrderer(options.orderer_url, { 
        'pem': caroots, 
        'ssl-target-name-override': "orderer1.example.com" 
    }); 
    channel.addOrderer(orderer); 
    targets.push(peer); 
    return; 
}).then(() => { 
	// get a transaction id object based on the current user assigned to fabric client
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
        chaincodeId: options.chaincode_id, 
        fcn: 'write', 
        args: ['$key','$value'],
        //args: ['k', makeid(30*1000*1000)], // 1000 * 1000 = 1M
        chainId: options.channel_id, 
        txId: tx_id 
    }; 
	// Peer received proposal result of proposed transaction
    return channel.sendTransactionProposal(request); 
}).then((results) => { 
    var proposalResponses = results[0]; 
    var proposal = results[1]; 
    var header = results[2]; 
    let isProposalGood = false; 
    if (proposalResponses && proposalResponses[0].response && 
        proposalResponses[0].response.status === 200) { 
        isProposalGood = true; 
        //console.log('transaction_proposal_was_good: %j', Date.now()/1000); 
    } else { 
        console.error('transaction_proposal_was_bad: %j', Date.now()/1000); 
    }
 	if (isProposalGood) {
		var request = {
            proposalResponses: proposalResponses,
            proposal: proposal
        };
		var transaction_id_string = tx_id.getTransactionID(); //Get the transaction ID string to be used by the event processing
        var promises = [];
		var sendPromise = channel.sendTransaction(request);
        // Peer sends the successful proposed transaction
        start_counter = Date.now()/1000;
        promises.push(sendPromise); //we want the send transaction first, so that we know where to check status		
        let event_hub = channel.newChannelEventHub('localhost:7051');
        // EventHub to listen whenther the transaction has been fianlly accepted
        let data = fs.readFileSync(options.peer_tls_cacerts);
        let grpcOpts = {
             pem: Buffer.from(data).toString(),
            'ssl-target-name-override': options.server_hostname
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
    } else {
        console.error('Failed to order the transaction. Error code: ' + response.status);
    }
    if(results && results[1] && results[1].event_status === 'VALID') {
    } else {
        console.log('Transaction failed to be committed to the ledger due to ::'+results[1].event_status);
    }
}).catch((err) => {
    console.error('Failed to invoke successfully :: ' + err);
});
EOF


cat>/home/t716/fabric-dbench/fabric-samples/sdk.org1.example.com/invoke_or_individual.sh<<EOF
node /home/t716/fabric-dbench/fabric-samples/sdk.org1.example.com/invoke_or_individual.js
EOF
chmod +x /home/t716/fabric-dbench/fabric-samples/sdk.org1.example.com/invoke_or_individual.sh



echo "------------------------------------------------------------"
echo "Copy SDK invoke_or_individual.js to All Peers"
echo "------------------------------------------------------------"
for ((i=2;i<=$ORGS;i++))
do
	cp -rf /home/t716/fabric-dbench/fabric-samples/sdk.org1.example.com/invoke_or_individual.js /home/t716/fabric-dbench/fabric-samples/sdk.org$i.example.com/invoke_or_individual.js
	sed -i "s/org1/org$i/g" /home/t716/fabric-dbench/fabric-samples/sdk.org$i.example.com/invoke_or_individual.js
    sed -i "s/Org1/Org$i/g" /home/t716/fabric-dbench/fabric-samples/sdk.org$i.example.com/invoke_or_individual.js
    cp -rf /home/t716/fabric-dbench/fabric-samples/sdk.org1.example.com/invoke_or_individual.sh /home/t716/fabric-dbench/fabric-samples/sdk.org$i.example.com/invoke_or_individual.sh
	sed -i "s/org1/org$i/g" /home/t716/fabric-dbench/fabric-samples/sdk.org$i.example.com/invoke_or_individual.sh
done


# copy sdk files to each remote peer

for ((i=2;i<=$ORGS;i++))
do
    ssh t716@peer0.org$i.example.com "echo [T716rrs722] | sudo rm -rf $HOME/fabric-dbench/fabric-samples"
done

for ((i=2;i<=$ORGS;i++))
do
    scp -r /home/t716/fabric-dbench/fabric-samples t716@peer0.org$i.example.com:/home/t716/fabric-dbench
done
