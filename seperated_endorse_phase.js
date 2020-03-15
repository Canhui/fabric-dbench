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
var counter = 10;
var t1;
var t2;
var t3;
var t4;
var endorsed_transactions = [];

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
        schedule();
	}
)


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


function a_plus(results){
    var proposalResponses = results[0];
        var proposal = results[1];
        var header = results[2];
        let isProposalGood = false;
        if (proposalResponses && proposalResponses[0].response &&
            proposalResponses[0].response.status === 200) {
            isProposalGood = true;
            t2 = Date.now()/1000;
            console.log('Get_Endorsed_Proposal: %j', t2);
            //console.log('transaction_proposal_was_good: %j', Date.now()/1000); 
        } else {
            console.error('transaction_proposal_was_bad: %j', Date.now()/1000);
        }
        console.log('Delay_Phrase1: %j', t2-t1);
}



async function run(){
	var return_a = await a();
    var res2 = await a_plus(return_a);
}


function asy(threads){
    try{
        for(var i=0; i < threads; i++){
            run();
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
}