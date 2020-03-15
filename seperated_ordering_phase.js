'use strict';

var hfc = require('fabric-client'); 
var path = require('path'); 
var util = require('util'); 
var sdkUtils = require('fabric-client/lib/utils') 
const fs = require('fs'); 

var options = { 
    user_id: 'Admin@org20.example.com', 
    msp_id:'Org20MSP', 
    channel_id: 'mychannel16', 
    chaincode_id: 'demo16', 
    peer_url: 'grpcs://localhost:7051',// TLS->grpcs; no TLS->grpc 
    event_url: 'grpcs://localhost:7053',
    orderer_url: 'grpcs://orderer1.example.com:7050',
    privateKeyFolder:'/home/t716/fabric-dbench/fabric-samples/Admin@org20.example.com/msp/keystore', 
    signedCert:'/home/t716/fabric-dbench/fabric-samples/Admin@org20.example.com/msp/signcerts/Admin@org20.example.com-cert.pem', 
    peer_tls_cacerts:'/home/t716/fabric-dbench/fabric-samples/peer0.org20.example.com/tls/ca.crt', 
    orderer_tls_cacerts:'/home/t716/fabric-dbench/fabric-samples/orderer1.example.com/tls/ca.crt', 
    server_hostname: "peer0.org20.example.com" 
};

var channel = {}; 
var client = null; 
var targets = []; 
var tx_id = null; 
var start_counter;
var end_counter;
var counter = 1;
var t1;
var t2;
var t3;
var t4;
// var endorsed_transactions;
// var endorsed_transactions2;
var endorsed_transactions = [];
var Num_Endorsed_Txs = 50*counter;


var proposal_responses_array = [];
var proposal_array = [];
var proposal_good_array = [];
            

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
let promise1 = new Promise(
    function(resolve, reject) {
        resolve();
    }
);

promise1.then(
    function(){
        client = new hfc();
        var     createUserOpt = {
                username: options.user_id,
                mspid: options.msp_id,
                cryptoContent: { privateKey: getKeyFilesInDir(options.privateKeyFolder)[0], signedCert: options.signedCert }
        }

        return sdkUtils.newKeyValueStore({
                    path: "/tmp/fabric-client-stateStore/"
                }).then((store) => {
                    client.setStateStore(store)
                    return client.createUser(createUserOpt)
        })

    }
).then(
    function(user){
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
    }

).then(
	function(){
        getEndorsedTransactions().then(
                      function(){
                            // setTimeout('endorsed_transactions',10000); // After get endorsed transactions, we wait 
                            // setTimeout(func,1000);
                            // b(endorsed_transactions[0][0]);
                            // console.log(endorsed_transactions);
                            // console.log(endorsed_transactions[0]);
                            // var jsonVal = JSON.parse(endorsed_transactions[0]);
                            // console.log(jsonVal[0][0].response.status);
                            // b(jsonVal);
                            // console.log(endorsed_transactions[0][0].response.status);
                            // console.log(endorsed_transactions[0][0].response.status);
                            // b_plus(proposal_responses_array[0], proposal_array[0]);
                            // b_plus(proposal_responses_array[1], proposal_array[1]);
                            // b_plus(proposal_responses_array[2], proposal_array[2]);
                            // b_plus(proposal_responses_array[3], proposal_array[3]);
                            // b_plus(proposal_responses_array[4], proposal_array[4]);
                            // getOrderedTransactions();
                            schedule();
                            // b(endorsed_transactions);
                            // b(endorsed_transactions2);
                            // b(endorsed_transactions2);
                            // var string = JSON.stringify(endorsed_transactions[0]);
                            // console.log(string[0][0]);
                            // var jsonobj1 = JSON.parse(endorsed_transactions[0]);
                            // console.log(jsonobj1);
                            // console.log(endorsed_transactions[0]);
                            // console.log(endorsed_transactions[0][0].response.status);
                            // console.log(endorsed_transactions[1]);
                      }
            )
        // var values = getValues();
        // console.log(values[0]);
        // console.log(values[1]);
        // var return_a = a();
        // var return_b = a();
        // console.log(return_a);
        // return [a(),a()];
        // return_a;
        // schedule();
	}
)

// .then(
    // function(returns){
        // console.log(returns);
        // console.log(returns[1]);
    // }
// )


async function getEndorsedTransactions() {
    for (var i = Num_Endorsed_Txs; i > 0; i--) {
        var res = await a();
        // console.log(typeof returns);
        // var jsonToStr = JSON.stringify(jsonVal);
        // console.log(val[0][0].response.status);
        // endorsed_transactions = jsonVal;
        // endorsed_transactions2 = await a();
        // proposal_good_array.push()
        proposal_responses_array.push(res[0]);
        // proposal_good_array.push(res[0].response.status);
        proposal_array.push(res[1]);
        // endorsed_transactions.push(jsonVal[0]);
    }
    // endorsed_transactions.push(await a());
    // endorsed_transactions.push(await a());
    // var return1 = await a();
    // var return2 = await a();
    // endorsed_transactions.push(return1);
    // endorsed_transactions.push(return2);
    // console.log(endorsed_transactions);
    // console.log(endorsed_transactions[0]);
    // console.log(endorsed_transactions[1]);
    // console.log(return1);
    // console.log(return2);
    // return [return1, return2];
    // Your logic goes here.
    // return endorsed_transactions;
}



async function getOrderedTransactions() {
    for (var i = 0; i < Num_Endorsed_Txs; i++) {
        var res = await b_plus(proposal_responses_array[i], proposal_array[i]);
        // console.log(typeof returns);
        console.log(res);
        t4 = Date.now()/1000;
        console.log('Get_Ordered_Transaction: %j', t4);
        // var jsonToStr = JSON.stringify(jsonVal);
        // console.log(val[0][0].response.status);
        // endorsed_transactions = jsonVal;
        // endorsed_transactions2 = await a();
        // proposal_good_array.push()
        // proposal_responses_array.push(res[0]);
        // proposal_good_array.push(res[0].response.status);
        // proposal_array.push(res[1]);
        // endorsed_transactions.push(jsonVal[0]);
    }
    // endorsed_transactions.push(await a());
    // endorsed_transactions.push(await a());
    // var return1 = await a();
    // var return2 = await a();
    // endorsed_transactions.push(return1);
    // endorsed_transactions.push(return2);
    // console.log(endorsed_transactions);
    // console.log(endorsed_transactions[0]);
    // console.log(endorsed_transactions[1]);
    // console.log(return1);
    // console.log(return2);
    // return [return1, return2];
    // Your logic goes here.
    // return endorsed_transactions;
}





// Get Endorsed Transactions from Endorser Nodes
function a(){
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
            fcn: 'set',
            //args: ['a','value1'],
            //args: ['a', makeid(1)], // 1000 * 1000 = 1M
	    args: ['a', makeid(1)],
            chainId: options.channel_id,
            txId: tx_id
        };
        t1 = Date.now()/1000;
        console.log('Send_Endorsing_Proposal: %j', t1);
        // Peer received proposal result of proposed transaction
        return channel.sendTransactionProposal(request);

}


// function a_plus(results){
//     var proposalResponses = results[0];
//         var proposal = results[1];
//         var header = results[2];
//         let isProposalGood = false;
//         if (proposalResponses && proposalResponses[0].response &&
//             proposalResponses[0].response.status === 200) {
//             isProposalGood = true;
//             t2 = Date.now()/1000;
//             console.log('Get_Endorsed_Proposal: %j', t2);
//             //console.log('transaction_proposal_was_good: %j', Date.now()/1000); 
//         } else {
//             console.error('transaction_proposal_was_bad: %j', Date.now()/1000);
//         }
//         console.log('Delay_Phrase1: %j', t2-t1);
// }


// Get Orderered Blocks from Ordering Service Nodes
// function b(results){
// 	var proposalResponses = results[0];
//         var proposal = results[1];
//         var header = results[2];
//         let isProposalGood = false;
//         if (proposalResponses && proposalResponses[0].response &&
//             proposalResponses[0].response.status === 200) {
//             isProposalGood = true;
//             t2 = Date.now()/1000;
//             console.log('Get_Endorsed_Proposal: %j', t2);
//             //console.log('transaction_proposal_was_good: %j', Date.now()/1000); 
//         } else {
//             console.error('transaction_proposal_was_bad: %j', Date.now()/1000);
//         }
//         if (isProposalGood) {
//             var request = {
//                 proposalResponses: proposalResponses,
//                 proposal: proposal
//             };
//             var transaction_id_string = tx_id.getTransactionID(); //Get the transaction ID string to be used by the event processing
//             var promises = [];
//             console.log(request); // debug used purposes only
//             var sendPromise = channel.sendTransaction(request);
//             // Peer sends the successful proposed transaction
//             start_counter = Date.now()/1000;
//             t3 = Date.now()/1000;
//             console.log('Send_Ordering_Transaction: %j', t3);
//             promises.push(sendPromise); //we want the send transaction first, so that we know where to check status         
//             let event_hub = channel.newChannelEventHub('localhost:7051');
// 	       // EventHub to listen whenther the transaction has been fianlly accepted
//             let data = fs.readFileSync(options.peer_tls_cacerts);
//             let grpcOpts = {
//                 pem: Buffer.from(data).toString(),
//                 'ssl-target-name-override': options.server_hostname
//             }
//             let txPromise = new Promise((resolve, reject) => {
//                 let handle = setTimeout(() => {
//                     event_hub.disconnect();
//                     resolve({event_status : 'TIMEOUT'}); //we could use reject(new Error('Trnasaction did not complete within 30 seconds'));
//                 }, 3000);
//                 event_hub.connect();
//                 event_hub.registerTxEvent(transaction_id_string, (tx, code) => {
//                 // this is the callback for transaction event status
//                 // first some clean up of event listener
//                     clearTimeout(handle);
//                     event_hub.unregisterTxEvent(transaction_id_string);
//                     event_hub.disconnect();
//                     var return_status = {event_status : code, tx_id : transaction_id_string};
//                     if (code !== 'VALID') {
//                         console.error('transaction_invalid: %j', Date.now()/1000);
//                         resolve(return_status); // we could use reject(new Error('Problem with the tranaction, event status ::'+code));
//                     } else {
//                     resolve(return_status);
//                     }
//                 });          
//             });
//             promises.push(txPromise);
//             return Promise.all(promises);
// 	    } else {
//             //console.error([Date.now()/1000],'Failed to send Proposal or receive valid response. Response null or status is not 200. exiting...');
//             throw new Error('Failed to send Proposal or receive valid response. Response null or status is not 200. exiting...');
//     	}
// }


// Get Orderered Blocks from Ordering Service Nodes
function b_plus(proposalResponses, proposal){
    // var proposalResponses = results[0];
    //     var proposal = results[1];
    //     var header = results[2];
    //     let isProposalGood = false;
    //     if (proposalResponses && proposalResponses[0].response &&
    //         proposalResponses[0].response.status === 200) {
    //         isProposalGood = true;
    //         t2 = Date.now()/1000;
    //         console.log('Get_Endorsed_Proposal: %j', t2);
    //         //console.log('transaction_proposal_was_good: %j', Date.now()/1000); 
    //     } else {
    //         console.error('transaction_proposal_was_bad: %j', Date.now()/1000);
    //     }
        // if (isProposalGood) {
            var request = {
                proposalResponses: proposalResponses,
                proposal: proposal
            };
            var transaction_id_string = tx_id.getTransactionID(); //Get the transaction ID string to be used by the event processing
            var promises = [];
            console.log(request); // debug used purposes only
            var sendPromise = channel.sendTransaction(request);
            // Peer sends the successful proposed transaction
            start_counter = Date.now()/1000;
            t3 = Date.now()/1000;
            console.log('Send_Ordering_Transaction: %j', t3);
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
                });          
            });
            promises.push(txPromise);
            return Promise.all(promises);
        // } else {
        //     //console.error([Date.now()/1000],'Failed to send Proposal or receive valid response. Response null or status is not 200. exiting...');
        //     throw new Error('Failed to send Proposal or receive valid response. Response null or status is not 200. exiting...');
        // }
}




// Statistics
// function c(results){
// 	var end_counter = Date.now()/1000;
//         t4 = Date.now()/1000;
//         console.log('Get_Ordered_Transaction: %j', t4);
//         console.log('Delay_Phrase1: %j', t2-t1);
//         console.log('Delay_Phrase2: %j', t4-t3);
//         //console.log(end_counter-start_counter+','+ Date.now()/1000)
//         if (results && results[0] && results[0].status === 'SUCCESS'){
// 	    if(results && results[1] && results[1].event_status === 'VALID'){
// 		console.log('Get_Ordered_Transaction(ordered_and_valid): %j', t4);
// 	    } else{
// 		console.log('Get_Ordered_Transaction(ordered_not_valid): %j', t4);
// 	    }
//         } else {
// 		console.log("failed to get results from ordering service");
// 	}        
// }



async function run(i){
	// var return_a = await a();
    // var res2 = await a_plus(return_a);
    var res = await b_plus(proposal_responses_array[i], proposal_array[i]);
    // console.log(typeof returns);
    // console.log(res);
    t4 = Date.now()/1000;
    console.log('Get_Ordered_Transaction: %j', t4);
    // console.log(return_a[0][0]);
    // console.log(return_a); // sleep ten seconds after finished and save these responses. Save a'response into an array, and count how many numbers there
    // endorsed_transactions.push(return_a);
    // console.log(return_a);
    // Question: how to save these responses???
	// var return_b = await b(return_a); // after the first phase finished, we finished the first phase and start the ordering phase.
	// c(return_b);
}


function asy(threads){
    try{
        for(var i=0; i < threads; i++){
            run(i);
        }
    } catch(e){
    }
}

function do_it(callback){
    //asy(100);
    asy(50);
    callback();
}

function schedule(){
    counter--;
    if(counter >= 0){
        //setTimeout(do_it, 900, schedule);
        setTimeout(do_it, 900, schedule);
    }
    // console.log(endorsed_transactions);
}