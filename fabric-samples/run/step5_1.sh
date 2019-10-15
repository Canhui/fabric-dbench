ORGS=3
chaincode_name="demo2"
channel_name="mychannel2"


echo "------------------------------------------------------------"
echo "Clean SDK Environment"
echo "------------------------------------------------------------"
rm -rf /home/t716/fabric-dbench/fabric-samples/sdk.org*.example.com


echo "------------------------------------------------------------"
echo "Org1 Configure Nodejs SDK Environment"
echo "------------------------------------------------------------"
mkdir /home/t716/fabric-dbench/fabric-samples/sdk.org1.example.com
cat>/home/t716/fabric-dbench/fabric-samples/sdk.org1.example.com/package.json<<EOF
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
    "author": "chwang@comp.hkbu.edu.hk",
    "license": "Apache-2.0",
    "keywords": [
        "Hyperledger",
        "Fabric",
        "Test",
        "Application"
    ]
}
EOF
cd /home/t716/fabric-dbench/fabric-samples/sdk.org1.example.com
npm install



echo "------------------------------------------------------------"
echo "Org1 Creates query.js"
echo "------------------------------------------------------------"
cat>/home/t716/fabric-dbench/fabric-samples/sdk.org1.example.com/query.js<<EOF
var hfc = require('fabric-client');
var path = require('path');
var sdkUtils = require('fabric-client/lib/utils');
var fs = require('fs');
var options = {
    user_id:'Admin@org1.example.com',
    msp_id:'Org1MSP',
    channel_id:'$channel_name',
    chaincode_id:'$chaincode_name',
    network_url:'grpcs://peer0.org1.example.com:7051',
    privateKeyFolder:'/home/t716/fabric-dbench/fabric-samples/Admin@org1.example.com/msp/keystore',
    signedCert:'/home/t716/fabric-dbench/fabric-samples/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem',
    tls_cacerts:'/home/t716/fabric-dbench/fabric-samples/peer0.org1.example.com/tls/ca.crt',
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
EOF

cat>/home/t716/fabric-dbench/fabric-samples/sdk.org1.example.com/query.sh<<EOF
node /home/t716/fabric-dbench/fabric-samples/sdk.org1.example.com/query.js
EOF
chmod +x /home/t716/fabric-dbench/fabric-samples/sdk.org1.example.com/query.sh



echo "------------------------------------------------------------"
echo "Copy SDK query.js to All Peers"
echo "------------------------------------------------------------"
for ((i=2;i<=$ORGS;i++))
do
    cp -rf  /home/t716/fabric-dbench/fabric-samples/sdk.org1.example.com/ /home/t716/fabric-dbench/fabric-samples/sdk.org$i.example.com/
    sed -i "s/org1/org$i/g" /home/t716/fabric-dbench/fabric-samples/sdk.org$i.example.com/query.js
    sed -i "s/Org1/Org$i/g" /home/t716/fabric-dbench/fabric-samples/sdk.org$i.example.com/query.js
    sed -i "s/org1/org$i/g" /home/t716/fabric-dbench/fabric-samples/sdk.org$i.example.com/query.sh
done
