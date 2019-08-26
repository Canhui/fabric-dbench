## 1. 配置Peer/Orderer所属IP

```shell
192.168.0.103 orderer.example.com
192.168.0.103 peer0.org1.example.com
192.168.0.106 peer0.org2.example.com
```


<br />
<br />

## 2. 准备证书 (Orderer+Peers)

**步骤2.1.** 创建"cryptogen.yaml"文件，1.4版本"crypto-config.yaml"文件更改为"cryptogen.yaml"，文件于"cd $HOME/fabric-samples"路径下，


```shell
$ cd $HOME/fabric-samples
~/fabric-samples$ vi cryptogen.yaml
```


```yaml
OrdererOrgs:
  - Name: Orderer
    #Domain: orgorderer1
    Domain: example.com
    CA:
        Country: CN
        Province: HongKong
        Locality: HongKong
    Specs:
      - Hostname: orderer
        SANS:
          - "localhost"
          - "127.0.0.1"
      
PeerOrgs:
  - Name: Org1
    Domain: org1.example.com
    EnableNodeOUs: true
    CA:
        Country: CN
        Province: HongKong
        Locality: HongKong
    Template:
      Count: 1
      SANS:
          - "localhost"
          - "127.0.0.1"
    Users:
      Count: 1
  - Name: Org2
    Domain: org2.example.com
    EnableNodeOUs: true
    CA:
        Country: CN
        Province: HongKong
        Locality: HongKong
    Template:
      Count: 1
      SANS:
          - "localhost"
          - "127.0.0.1"
    Users:
      Count: 1
```


**步骤2.2.** 生成配置文件，并将配置文件写入"certs"文件夹。

```shell
/fabric-samples$ ./bin/cryptogen generate --config=./cryptogen.yaml --output ./certs
```


<br />
<br />




## 3. 配置Orderer

**步骤3.1.** 新建"orderer.example.com"文件夹，用于存放Orderer节点启动运行所需的全部文件。

```shell
~/fabric-samples$ mkdir orderer.example.com
```

**步骤3.2.** 拷贝“fabric-samples/bin/orderer”到文件夹。
```shell
~/fabric-samples$ cp bin/orderer orderer.example.com/
```

**步骤3.3.** 拷贝"fabric-sample/certs/ordererOrganizations/example.com/orderers/orderer.example.com/"路径下的所有内容到文件夹。
```shell
~/fabric-samples$ cp -rf certs/ordererOrganizations/example.com/orderers/orderer.example.com/* orderer.example.com/
```

**步骤3.4.** 创建"orderer.yaml"文件到"orderer.example.com"文件夹下。
```shell
~/fabric-samples/orderer.example.com$ vi orderer.yaml
```

并往"orderer.yaml"中写入下列内容。

```yaml
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

---
################################################################################
#
#   Orderer Configuration
#
#   - This controls the type and configuration of the orderer.
#
################################################################################
General:

    # Ledger Type: The ledger type to provide to the orderer.
    # Two non-production ledger types are provided for test purposes only:
    #  - ram: An in-memory ledger whose contents are lost on restart.
    #  - json: A simple file ledger that writes blocks to disk in JSON format.
    # Only one production ledger type is provided:
    #  - file: A production file-based ledger.
    LedgerType: file

    # Listen address: The IP on which to bind to listen.
    ListenAddress: 0.0.0.0

    # Listen port: The port on which to bind to listen.
    ListenPort: 7050

    # TLS: TLS settings for the GRPC server.
    TLS:
        Enabled: true
        # PrivateKey governs the file location of the private key of the TLS certificate.
        PrivateKey: ./tls/server.key
        # Certificate governs the file location of the server TLS certificate.
        Certificate: ./tls/server.crt
        RootCAs:
          - ./tls/ca.crt
        ClientAuthRequired: true
        ClientRootCAs:
    # Keepalive settings for the GRPC server.
    Keepalive:
        # ServerMinInterval is the minimum permitted time between client pings.
        # If clients send pings more frequently, the server will
        # disconnect them.
        ServerMinInterval: 60s
        # ServerInterval is the time between pings to clients.
        ServerInterval: 7200s
        # ServerTimeout is the duration the server waits for a response from
        # a client before closing the connection.
        ServerTimeout: 20s

    # Genesis method: The method by which the genesis block for the orderer
    # system channel is specified. Available options are "provisional", "file":
    #  - provisional: Utilizes a genesis profile, specified by GenesisProfile,
    #                 to dynamically generate a new genesis block.
    #  - file: Uses the file provided by GenesisFile as the genesis block.
    # GenesisMethod: provisional
    GenesisMethod: file

    # Genesis profile: The profile to use to dynamically generate the genesis
    # block to use when initializing the orderer system channel and
    # GenesisMethod is set to "provisional". See the configtx.yaml file for the
    # descriptions of the available profiles. Ignored if GenesisMethod is set to
    # "file".
    GenesisProfile: SampleInsecureSolo

    # Genesis file: The file containing the genesis block to use when
    # initializing the orderer system channel and GenesisMethod is set to
    # "file". Ignored if GenesisMethod is set to "provisional".
    GenesisFile: ./genesisblock

    # LocalMSPDir is where to find the private crypto material needed by the
    # orderer. It is set relative here as a default for dev environments but
    # should be changed to the real location in production.
    LocalMSPDir: ./msp

    # LocalMSPID is the identity to register the local MSP material with the MSP
    # manager. IMPORTANT: The local MSP ID of an orderer needs to match the MSP
    # ID of one of the organizations defined in the orderer system channel's
    # /Channel/Orderer configuration. The sample organization defined in the
    # sample configuration provided has an MSP ID of "SampleOrg".
    LocalMSPID: OrdererMSP

    # Enable an HTTP service for Go "pprof" profiling as documented at:
    # https://golang.org/pkg/net/http/pprof
    Profile:
        Enabled: false
        Address: 0.0.0.0:6060

    # BCCSP configures the blockchain crypto service providers.
    BCCSP:
        # Default specifies the preferred blockchain crypto service provider
        # to use. If the preferred provider is not available, the software
        # based provider ("SW") will be used.
        # Valid providers are:
        #  - SW: a software based crypto provider
        #  - PKCS11: a CA hardware security module crypto provider.
        Default: SW

        # SW configures the software based blockchain crypto provider.
        SW:
            # TODO: The default Hash and Security level needs refactoring to be
            # fully configurable. Changing these defaults requires coordination
            # SHA2 is hardcoded in several places, not only BCCSP
            Hash: SHA2
            Security: 256
            # Location of key store. If this is unset, a location will be
            # chosen using: 'LocalMSPDir'/keystore
            FileKeyStore:
                KeyStore:

    # Authentication contains configuration parameters related to authenticating
    # client messages
    Authentication:
        # the acceptable difference between the current server time and the
        # client's time as specified in a client request message
        TimeWindow: 15m

################################################################################
#
#   SECTION: File Ledger
#
#   - This section applies to the configuration of the file or json ledgers.
#
################################################################################
FileLedger:

    # Location: The directory to store the blocks in.
    # NOTE: If this is unset, a new temporary location will be chosen every time
    # the orderer is restarted, using the prefix specified by Prefix.
    # Location: /var/hyperledger/production/orderer
    Location:  /opt/app/fabric/orderer/data

    # The prefix to use when generating a ledger directory in temporary space.
    # Otherwise, this value is ignored.
    # Prefix: hyperledger-fabric-ordererledger
    Prefix: hyperledger-fabric-ordererledger

################################################################################
#
#   SECTION: RAM Ledger
#
#   - This section applies to the configuration of the RAM ledger.
#
################################################################################
RAMLedger:

    # History Size: The number of blocks that the RAM ledger is set to retain.
    # WARNING: Appending a block to the ledger might cause the oldest block in
    # the ledger to be dropped in order to limit the number total number blocks
    # to HistorySize. For example, if history size is 10, when appending block
    # 10, block 0 (the genesis block!) will be dropped to make room for block 10.
    HistorySize: 1000

################################################################################
#
#   SECTION: Kafka
#
#   - This section applies to the configuration of the Kafka-based orderer, and
#     its interaction with the Kafka cluster.
#
################################################################################
Kafka:

    # Retry: What do if a connection to the Kafka cluster cannot be established,
    # or if a metadata request to the Kafka cluster needs to be repeated.
    Retry:
        # When a new channel is created, or when an existing channel is reloaded
        # (in case of a just-restarted orderer), the orderer interacts with the
        # Kafka cluster in the following ways:
        # 1. It creates a Kafka producer (writer) for the Kafka partition that
        # corresponds to the channel.
        # 2. It uses that producer to post a no-op CONNECT message to that
        # partition
        # 3. It creates a Kafka consumer (reader) for that partition.
        # If any of these steps fail, they will be re-attempted every
        # <ShortInterval> for a total of <ShortTotal>, and then every
        # <LongInterval> for a total of <LongTotal> until they succeed.
        # Note that the orderer will be unable to write to or read from a
        # channel until all of the steps above have been completed successfully.
        ShortInterval: 5s
        ShortTotal: 10m
        LongInterval: 5m
        LongTotal: 12h
        # Affects the socket timeouts when waiting for an initial connection, a
        # response, or a transmission. See Config.Net for more info:
        # https://godoc.org/github.com/Shopify/sarama#Config
        NetworkTimeouts:
            DialTimeout: 10s
            ReadTimeout: 10s
            WriteTimeout: 10s
        # Affects the metadata requests when the Kafka cluster is in the middle
        # of a leader election.See Config.Metadata for more info:
        # https://godoc.org/github.com/Shopify/sarama#Config
        Metadata:
            RetryBackoff: 250ms
            RetryMax: 3
        # What to do if posting a message to the Kafka cluster fails. See
        # Config.Producer for more info:
        # https://godoc.org/github.com/Shopify/sarama#Config
        Producer:
            RetryBackoff: 100ms
            RetryMax: 3
        # What to do if reading from the Kafka cluster fails. See
        # Config.Consumer for more info:
        # https://godoc.org/github.com/Shopify/sarama#Config
        Consumer:
            RetryBackoff: 2s
    # Verbose: Enable logging for interactions with the Kafka cluster.
    Verbose: false

    # TLS: TLS settings for the orderer's connection to the Kafka cluster.
    TLS:

      # Enabled: Use TLS when connecting to the Kafka cluster.
      Enabled: false

      # PrivateKey: PEM-encoded private key the orderer will use for
      # authentication.
      PrivateKey:
        # As an alternative to specifying the PrivateKey here, uncomment the
        # following "File" key and specify the file name from which to load the
        # value of PrivateKey.
        #File: path/to/PrivateKey

      # Certificate: PEM-encoded signed public key certificate the orderer will
      # use for authentication.
      Certificate:
        # As an alternative to specifying the Certificate here, uncomment the
        # following "File" key and specify the file name from which to load the
        # value of Certificate.
        #File: path/to/Certificate

      # RootCAs: PEM-encoded trusted root certificates used to validate
      # certificates from the Kafka cluster.
      RootCAs:
        # As an alternative to specifying the RootCAs here, uncomment the
        # following "File" key and specify the file name from which to load the
        # value of RootCAs.
        #File: path/to/RootCA

    # Kafka protocol version used to communicate with the Kafka cluster brokers
    # (defaults to 0.10.2.0 if not specified)
    Version:
```

**步骤3.5.** 新建data目录存放orderer数据。

```shell
~/fabric-samples/orderer.example.com$ mkdir data
```



## 4. 创建peer0.org1.example.com

**步骤4.1.** 新建"peer0.org1.example.com"文件夹，用于存放peer0.org1节点启动运行所需的全部文件。

```shell
~/fabric-samples$ mkdir peer0.org1.example.com
```

**步骤4.2.** 拷贝“fabric-samples/bin/peer”到文件夹。

```shell
~/fabric-samples$ cp bin/peer peer0.org1.example.com/
```

**步骤4.3.** 拷贝"fabric-sample/certs/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/"路径下的所有内容到文件夹。

```shell
~/fabric-samples$ cp -rf certs/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/* peer0.org1.example.com/
```


**步骤4.4.** 创建"core.yaml"文件到"peer0.org1.example.com"文件夹下。

```shell
~/fabric-samples$ cd peer0.org1.example.com
~/fabric-samples/peer0.org1.example.com$ touch core.yaml
```

并往"core.yaml"中写入下列内容。

```yaml
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

###############################################################################
#
#    LOGGING section
#
###############################################################################
logging:

    # Default logging levels are specified here.

    # Valid logging levels are case-insensitive strings chosen from

    #     CRITICAL | ERROR | WARNING | NOTICE | INFO | DEBUG

    # The overall default logging level can be specified in various ways,
    # listed below from strongest to weakest:
    #
    # 1. The --logging-level=<level> command line option overrides all other
    #    default specifications.
    #
    # 2. The environment variable CORE_LOGGING_LEVEL otherwise applies to
    #    all peer commands if defined as a non-empty string.
    #
    # 3. The value of `level` that directly follows in this file.
    #
    # If no overall default level is provided via any of the above methods,
    # the peer will default to INFO (the value of defaultLevel in
    # common/flogging/logging.go)

    # Default for all modules running within the scope of a peer.
    # Note: this value is only used when --logging-level or CORE_LOGGING_LEVEL
    #       are not set
    level:       info

    # The overall default values mentioned above can be overridden for the
    # specific components listed in the override section below.

    # Override levels for various peer modules. These levels will be
    # applied once the peer has completely started. They are applied at this
    # time in order to be sure every logger has been registered with the
    # logging package.
    # Note: the modules listed below are the only acceptable modules at this
    #       time.
    cauthdsl:   warning
    gossip:     warning
    grpc:       error
    ledger:     info
    msp:        warning
    policies:   warning
    peer:
        gossip: warning

    # Message format for the peer logs
    format: '%{color}%{time:2006-01-02 15:04:05.000 MST} [%{module}] %{shortfunc} -> %{level:.4s} %{id:03x}%{color:reset} %{message}'

###############################################################################
#
#    Peer section
#
###############################################################################
peer:

    # The Peer id is used for identifying this Peer instance.
    id: peer0.org1.example.com

    # The networkId allows for logical seperation of networks
    networkId: dev

    # The Address at local network interface this Peer will listen on.
    # By default, it will listen on all network interfaces
    listenAddress: 0.0.0.0:7051

    # The endpoint this peer uses to listen for inbound chaincode connections.
    # If this is commented-out, the listen address is selected to be
    # the peer's address (see below) with port 7052
    # chaincodeListenAddress: 0.0.0.0:7052

    # The endpoint the chaincode for this peer uses to connect to the peer.
    # If this is not specified, the chaincodeListenAddress address is selected.
    # And if chaincodeListenAddress is not specified, address is selected from
    # peer listenAddress.
    # chaincodeAddress: 0.0.0.0:7052

    # When used as peer config, this represents the endpoint to other peers
    # in the same organization. For peers in other organization, see
    # gossip.externalEndpoint for more info.
    # When used as CLI config, this means the peer's endpoint to interact with
    address: 0.0.0.0:7051

    # Whether the Peer should programmatically determine its address
    # This case is useful for docker containers.
    addressAutoDetect: false

    # Setting for runtime.GOMAXPROCS(n). If n < 1, it does not change the
    # current setting
    gomaxprocs: -1

    # Keepalive settings for peer server and clients
    keepalive:
        # MinInterval is the minimum permitted time between client pings.
        # If clients send pings more frequently, the peer server will
        # disconnect them
        minInterval: 60s
        # Client keepalive settings for communicating with other peer nodes
        client:
            # Interval is the time between pings to peer nodes.  This must
            # greater than or equal to the minInterval specified by peer
            # nodes
            interval: 60s
            # Timeout is the duration the client waits for a response from
            # peer nodes before closing the connection
            timeout: 20s
        # DeliveryClient keepalive settings for communication with ordering
        # nodes.
        deliveryClient:
            # Interval is the time between pings to ordering nodes.  This must
            # greater than or equal to the minInterval specified by ordering
            # nodes.
            interval: 60s
            # Timeout is the duration the client waits for a response from
            # ordering nodes before closing the connection
            timeout: 20s


    # Gossip related configuration
    gossip:
        # Bootstrap set to initialize gossip with.
        # This is a list of other peers that this peer reaches out to at startup.
        # Important: The endpoints here have to be endpoints of peers in the same
        # organization, because the peer would refuse connecting to these endpoints
        # unless they are in the same organization as the peer.
        bootstrap: 127.0.0.1:7051
        bootstrap: peer0.org1.example.com:7051

        # NOTE: orgLeader and useLeaderElection parameters are mutual exclusive.
        # Setting both to true would result in the termination of the peer
        # since this is undefined state. If the peers are configured with
        # useLeaderElection=false, make sure there is at least 1 peer in the
        # organization that its orgLeader is set to true.

        # Defines whenever peer will initialize dynamic algorithm for
        # "leader" selection, where leader is the peer to establish
        # connection with ordering service and use delivery protocol
        # to pull ledger blocks from ordering service. It is recommended to
        # use leader election for large networks of peers.
        useLeaderElection: true
        # Statically defines peer to be an organization "leader",
        # where this means that current peer will maintain connection
        # with ordering service and disseminate block across peers in
        # its own organization
        orgLeader: false

        # Overrides the endpoint that the peer publishes to peers
        # in its organization. For peers in foreign organizations
        # see 'externalEndpoint'
        endpoint:
        # Maximum count of blocks stored in memory
        maxBlockCountToStore: 100
        # Max time between consecutive message pushes(unit: millisecond)
        maxPropagationBurstLatency: 10ms
        # Max number of messages stored until a push is triggered to remote peers
        maxPropagationBurstSize: 10
        # Number of times a message is pushed to remote peers
        propagateIterations: 1
        # Number of peers selected to push messages to
        propagatePeerNum: 3
        # Determines frequency of pull phases(unit: second)
        # Must be greater than digestWaitTime + responseWaitTime
        pullInterval: 4s
        # Number of peers to pull from
        pullPeerNum: 3
        # Determines frequency of pulling state info messages from peers(unit: second)
        requestStateInfoInterval: 4s
        # Determines frequency of pushing state info messages to peers(unit: second)
        publishStateInfoInterval: 4s
        # Maximum time a stateInfo message is kept until expired
        stateInfoRetentionInterval:
        # Time from startup certificates are included in Alive messages(unit: second)
        publishCertPeriod: 10s
        # Should we skip verifying block messages or not (currently not in use)
        skipBlockVerification: false
        # Dial timeout(unit: second)
        dialTimeout: 3s
        # Connection timeout(unit: second)
        connTimeout: 2s
        # Buffer size of received messages
        recvBuffSize: 20
        # Buffer size of sending messages
        sendBuffSize: 200
        # Time to wait before pull engine processes incoming digests (unit: second)
        # Should be slightly smaller than requestWaitTime
        digestWaitTime: 1s
        # Time to wait before pull engine removes incoming nonce (unit: milliseconds)
        # Should be slightly bigger than digestWaitTime
        requestWaitTime: 1500ms
        # Time to wait before pull engine ends pull (unit: second)
        responseWaitTime: 2s
        # Alive check interval(unit: second)
        aliveTimeInterval: 5s
        # Alive expiration timeout(unit: second)
        aliveExpirationTimeout: 25s
        # Reconnect interval(unit: second)
        reconnectInterval: 25s
        # This is an endpoint that is published to peers outside of the organization.
        # If this isn't set, the peer will not be known to other organizations.
        externalEndpoint: peer0.org1.example.com:7051
        # Leader election service configuration
        election:
            # Longest time peer waits for stable membership during leader election startup (unit: second)
            startupGracePeriod: 15s
            # Interval gossip membership samples to check its stability (unit: second)
            membershipSampleInterval: 1s
            # Time passes since last declaration message before peer decides to perform leader election (unit: second)
            leaderAliveThreshold: 10s
            # Time between peer sends propose message and declares itself as a leader (sends declaration message) (unit: second)
            leaderElectionDuration: 5s

        pvtData:
            # pullRetryThreshold determines the maximum duration of time private data corresponding for a given block
            # would be attempted to be pulled from peers until the block would be committed without the private data
            pullRetryThreshold: 60s
            # As private data enters the transient store, it is associated with the peer's ledger's height at that time.
            # transientstoreMaxBlockRetention defines the maximum difference between the current ledger's height upon commit,
            # and the private data residing inside the transient store that is guaranteed not to be purged.
            # Private data is purged from the transient store when blocks with sequences that are multiples
            # of transientstoreMaxBlockRetention are committed.
            transientstoreMaxBlockRetention: 1000
            # pushAckTimeout is the maximum time to wait for an acknowledgement from each peer
            # at private data push at endorsement time.
            pushAckTimeout: 3s
            # Block to live pulling margin, used as a buffer
            # to prevent peer from trying to pull private data
            # from peers that is soon to be purged in next N blocks.
            # This helps a newly joined peer catch up to current
            # blockchain height quicker.
            btlPullMargin: 10

    # EventHub related configuration
    events:
        # The address that the Event service will be enabled on the peer
        address: 0.0.0.0:7053

        # total number of events that could be buffered without blocking send
        buffersize: 100

        # timeout configures how long to block when attempting to add an event to a full buffer:
        #   when timeout < 0 then discard the event and continue
        #   when timeout = 0 then block until event is added to the buffer
        #   when timeout > 0 then block and discard the event if the timeout expires
        timeout: 10ms

        # timewindow is the acceptable difference between the peer's current
        # time and the client's time as specified in a registration event
        timewindow: 15m

        # Keepalive settings for peer server and clients
        keepalive:
            # MinInterval is the minimum permitted time in seconds which clients
            # can send keepalive pings.  If clients send pings more frequently,
            # the events server will disconnect them
            minInterval: 60s

        # the timeout to send events over the GRPC stream to clients
        sendTimeout: 60s

    # TLS Settings
    # Note that peer-chaincode connections through chaincodeListenAddress is
    # not mutual TLS auth. See comments on chaincodeListenAddress for more info
    tls:
        # Require server-side TLS
        enabled:  true
        # Require client certificates / mutual TLS.
        # Note that clients that are not configured to use a certificate will
        # fail to connect to the peer.
        # clientAuthRequired: false
        # X.509 certificate used for TLS server
        cert:
            file: ./tls/server.crt
        # Private key used for TLS server (and client if clientAuthEnabled
        # is set to true
        key:
            file: ./tls/server.key
        # Trusted root certificate chain for tls.cert
        rootcert:
            file: ./tls/ca.crt
        # Set of root certificate authorities used to verify client certificates
        clientRootCAs:
            files:
              - ./tls/ca.crt
        # Private key used for TLS when making client connections.  If
        # not set, peer.tls.key.file will be used instead
        clientKey:
            file:
        # X.509 certificate used for TLS when making client connections.
        # If not set, peer.tls.cert.file will be used instead
        clientCert:
            file:

    # Authentication contains configuration parameters related to authenticating
    # client messages
    authentication:
        # the acceptable difference between the current server time and the
        # client's time as specified in a client request message
        timewindow: 15m

    # Path on the file system where peer will store data (eg ledger). This
    # location must be access control protected to prevent unintended
    # modification that might corrupt the peer operations.
    fileSystemPath: /opt/app/fabric/peer/data

    # BCCSP (Blockchain crypto provider): Select which crypto implementation or
    # library to use
    BCCSP:
        Default: SW
        # Settings for the SW crypto provider (i.e. when DEFAULT: SW)
        SW:
            # TODO: The default Hash and Security level needs refactoring to be
            # fully configurable. Changing these defaults requires coordination
            # SHA2 is hardcoded in several places, not only BCCSP
            Hash: SHA2
            Security: 256
            # Location of Key Store
            FileKeyStore:
                # If "", defaults to 'mspConfigPath'/keystore
                KeyStore:
        # Settings for the PKCS#11 crypto provider (i.e. when DEFAULT: PKCS11)
        PKCS11:
            # Location of the PKCS11 module library
            Library:
            # Token Label
            Label:
            # User PIN
            Pin:
            Hash:
            Security:
            FileKeyStore:
                KeyStore:

    # Path on the file system where peer will find MSP local configurations
    mspConfigPath: msp

    # Identifier of the local MSP
    # ----!!!!IMPORTANT!!!-!!!IMPORTANT!!!-!!!IMPORTANT!!!!----
    # Deployers need to change the value of the localMspId string.
    # In particular, the name of the local MSP ID of a peer needs
    # to match the name of one of the MSPs in each of the channel
    # that this peer is a member of. Otherwise this peer's messages
    # will not be identified as valid by other nodes.
    localMspId: Org1MSP

    # CLI common client config options
    client:
        # connection timeout
        connTimeout: 3s

    # Delivery service related config
    deliveryclient:
        # It sets the total time the delivery service may spend in reconnection
        # attempts until its retry logic gives up and returns an error
        reconnectTotalTimeThreshold: 3600s

        # It sets the delivery service <-> ordering service node connection timeout
        connTimeout: 3s

        # It sets the delivery service maximal delay between consecutive retries
        reConnectBackoffThreshold: 3600s

    # Type for the local MSP - by default it's of type bccsp
    localMspType: bccsp

    # Used with Go profiling tools only in none production environment. In
    # production, it should be disabled (eg enabled: false)
    profile:
        enabled:     false
        listenAddress: 0.0.0.0:6060

    # The admin service is used for administrative operations such as
    # control over log module severity, etc.
    # Only peer administrators can use the service.
    adminService:
        # The interface and port on which the admin server will listen on.
        # If this is commented out, or the port number is equal to the port
        # of the peer listen address - the admin service is attached to the
        # peer's service (defaults to 7051).
        #listenAddress: 0.0.0.0:7055

    # Handlers defines custom handlers that can filter and mutate
    # objects passing within the peer, such as:
    #   Auth filter - reject or forward proposals from clients
    #   Decorators  - append or mutate the chaincode input passed to the chaincode
    #   Endorsers   - Custom signing over proposal response payload and its mutation
    # Valid handler definition contains:
    #   - A name which is a factory method name defined in
    #     core/handlers/library/library.go for statically compiled handlers
    #   - library path to shared object binary for pluggable filters
    # Auth filters and decorators are chained and executed in the order that
    # they are defined. For example:
    # authFilters:
    #   -
    #     name: FilterOne
    #     library: /opt/lib/filter.so
    #   -
    #     name: FilterTwo
    # decorators:
    #   -
    #     name: DecoratorOne
    #   -
    #     name: DecoratorTwo
    #     library: /opt/lib/decorator.so
    # Endorsers are configured as a map that its keys are the endorsement system chaincodes that are being overridden.
    # Below is an example that overrides the default ESCC and uses an endorsement plugin that has the same functionality
    # as the default ESCC.
    # If the 'library' property is missing, the name is used as the constructor method in the builtin library similar
    # to auth filters and decorators.
    # endorsers:
    #   escc:
    #     name: DefaultESCC
    #     library: /etc/hyperledger/fabric/plugin/escc.so
    handlers:
        authFilters:
          -
            name: DefaultAuth
          -
            name: ExpirationCheck    # This filter checks identity x509 certificate expiration
        decorators:
          -
            name: DefaultDecorator
        endorsers:
          escc:
            name: DefaultEndorsement
            library:
        validators:
          vscc:
            name: DefaultValidation
            library:

    #    library: /etc/hyperledger/fabric/plugin/escc.so
    # Number of goroutines that will execute transaction validation in parallel.
    # By default, the peer chooses the number of CPUs on the machine. Set this
    # variable to override that choice.
    # NOTE: overriding this value might negatively influence the performance of
    # the peer so please change this value only if you know what you're doing
    validatorPoolSize:

    # The discovery service is used by clients to query information about peers,
    # such as - which peers have joined a certain channel, what is the latest
    # channel config, and most importantly - given a chaincode and a channel,
    # what possible sets of peers satisfy the endorsement policy.
    discovery:
        enabled: true
        # Whether the authentication cache is enabled or not.
        authCacheEnabled: true
        # The maximum size of the cache, after which a purge takes place
        authCacheMaxSize: 1000
        # The proportion (0 to 1) of entries that remain in the cache after the cache is purged due to overpopulation
        authCachePurgeRetentionRatio: 0.75
        # Whether to allow non-admins to perform non channel scoped queries.
        # When this is false, it means that only peer admins can perform non channel scoped queries.
        orgMembersAllowedAccess: false
###############################################################################
#
#    VM section
#
###############################################################################
vm:

    # Endpoint of the vm management system.  For docker can be one of the following in general
    # unix:///var/run/docker.sock
    # http://localhost:2375
    # https://localhost:2376
    endpoint: unix:///var/run/docker.sock

    # settings for docker vms
    docker:
        tls:
            enabled: false
            ca:
                file: docker/ca.crt
            cert:
                file: docker/tls.crt
            key:
                file: docker/tls.key

        # Enables/disables the standard out/err from chaincode containers for
        # debugging purposes
        attachStdout: false

        # Parameters on creating docker container.
        # Container may be efficiently created using ipam & dns-server for cluster
        # NetworkMode - sets the networking mode for the container. Supported
        # standard values are: `host`(default),`bridge`,`ipvlan`,`none`.
        # Dns - a list of DNS servers for the container to use.
        # Note:  `Privileged` `Binds` `Links` and `PortBindings` properties of
        # Docker Host Config are not supported and will not be used if set.
        # LogConfig - sets the logging driver (Type) and related options
        # (Config) for Docker. For more info,
        # https://docs.docker.com/engine/admin/logging/overview/
        # Note: Set LogConfig using Environment Variables is not supported.
        hostConfig:
            NetworkMode: host
            Dns:
               # - 192.168.0.1
            LogConfig:
                Type: json-file
                Config:
                    max-size: "50m"
                    max-file: "5"
            Memory: 2147483648

###############################################################################
#
#    Chaincode section
#
###############################################################################
chaincode:

    # The id is used by the Chaincode stub to register the executing Chaincode
    # ID with the Peer and is generally supplied through ENV variables
    # the `path` form of ID is provided when installing the chaincode.
    # The `name` is used for all other requests and can be any string.
    id:
        path:
        name:

    # Generic builder environment, suitable for most chaincode types
    builder: $(DOCKER_NS)/fabric-ccenv:latest

    # Enables/disables force pulling of the base docker images (listed below)
    # during user chaincode instantiation.
    # Useful when using moving image tags (such as :latest)
    pull: false

    golang:
        # golang will never need more than baseos
        runtime: $(BASE_DOCKER_NS)/fabric-baseos:$(ARCH)-$(BASE_VERSION)

        # whether or not golang chaincode should be linked dynamically
        dynamicLink: false

    car:
        # car may need more facilities (JVM, etc) in the future as the catalog
        # of platforms are expanded.  For now, we can just use baseos
        runtime: $(BASE_DOCKER_NS)/fabric-baseos:$(ARCH)-$(BASE_VERSION)

    java:
        # This is an image based on java:openjdk-8 with addition compiler
        # tools added for java shim layer packaging.
        # This image is packed with shim layer libraries that are necessary
        # for Java chaincode runtime.
        Dockerfile:  |
            from $(DOCKER_NS)/fabric-javaenv:$(ARCH)-1.1.0

    node:
        # need node.js engine at runtime, currently available in baseimage
        # but not in baseos
        runtime: $(BASE_DOCKER_NS)/fabric-baseimage:$(ARCH)-$(BASE_VERSION)

    # Timeout duration for starting up a container and waiting for Register
    # to come through. 1sec should be plenty for chaincode unit tests
    startuptimeout: 300s

    # Timeout duration for Invoke and Init calls to prevent runaway.
    # This timeout is used by all chaincodes in all the channels, including
    # system chaincodes.
    # Note that during Invoke, if the image is not available (e.g. being
    # cleaned up when in development environment), the peer will automatically
    # build the image, which might take more time. In production environment,
    # the chaincode image is unlikely to be deleted, so the timeout could be
    # reduced accordingly.
    executetimeout: 30s

    # There are 2 modes: "dev" and "net".
    # In dev mode, user runs the chaincode after starting peer from
    # command line on local machine.
    # In net mode, peer will run chaincode in a docker container.
    mode: net

    # keepalive in seconds. In situations where the communiction goes through a
    # proxy that does not support keep-alive, this parameter will maintain connection
    # between peer and chaincode.
    # A value <= 0 turns keepalive off
    keepalive: 0

    # system chaincodes whitelist. To add system chaincode "myscc" to the
    # whitelist, add "myscc: enable" to the list below, and register in
    # chaincode/importsysccs.go
    system:
        cscc: enable
        lscc: enable
        escc: enable
        vscc: enable
        qscc: enable

    # System chaincode plugins: in addition to being imported and compiled
    # into fabric through core/chaincode/importsysccs.go, system chaincodes
    # can also be loaded as shared objects compiled as Go plugins.
    # See examples/plugins/scc for an example.
    # Like regular system chaincodes, plugins must also be white listed in the
    # chaincode.system section above.
    systemPlugins:
      # example configuration:
      # - enabled: true
      #   name: myscc
      #   path: /opt/lib/myscc.so
      #   invokableExternal: true
      #   invokableCC2CC: true

    # Logging section for the chaincode container
    logging:
      # Default level for all loggers within the chaincode container
      level:  info
      # Override default level for the 'shim' module
      shim:   warning
      # Format for the chaincode container logs
      format: '%{color}%{time:2006-01-02 15:04:05.000 MST} [%{module}] %{shortfunc} -> %{level:.4s} %{id:03x}%{color:reset} %{message}'

###############################################################################
#
#    Ledger section - ledger configuration encompases both the blockchain
#    and the state
#
###############################################################################
ledger:

  blockchain:

  state:
    # stateDatabase - options are "goleveldb", "CouchDB"
    # goleveldb - default state database stored in goleveldb.
    # CouchDB - store state database in CouchDB
    stateDatabase: goleveldb
    couchDBConfig:
       # It is recommended to run CouchDB on the same server as the peer, and
       # not map the CouchDB container port to a server port in docker-compose.
       # Otherwise proper security must be provided on the connection between
       # CouchDB client (on the peer) and server.
       couchDBAddress: 127.0.0.1:5984
       # This username must have read and write authority on CouchDB
       username:
       # The password is recommended to pass as an environment variable
       # during start up (eg LEDGER_COUCHDBCONFIG_PASSWORD).
       # If it is stored here, the file must be access control protected
       # to prevent unintended users from discovering the password.
       password:
       # Number of retries for CouchDB errors
       maxRetries: 3
       # Number of retries for CouchDB errors during peer startup
       maxRetriesOnStartup: 10
       # CouchDB request timeout (unit: duration, e.g. 20s)
       requestTimeout: 35s
       # Limit on the number of records to return per query
       queryLimit: 10000
       # Limit on the number of records per CouchDB bulk update batch
       maxBatchUpdateSize: 1000
       # Warm indexes after every N blocks.
       # This option warms any indexes that have been
       # deployed to CouchDB after every N blocks.
       # A value of 1 will warm indexes after every block commit,
       # to ensure fast selector queries.
       # Increasing the value may improve write efficiency of peer and CouchDB,
       # but may degrade query response time.
       warmIndexesAfterNBlocks: 1

  history:
    # enableHistoryDatabase - options are true or false
    # Indicates if the history of key updates should be stored.
    # All history 'index' will be stored in goleveldb, regardless if using
    # CouchDB or alternate database for the state.
    enableHistoryDatabase: true
```



**步骤4.5.** 新建data目录存放peer0.org1数据。
```shell
~/fabric-samples/peer0.org1.example.com$ mkdir data
```

<br />
<br />



## 6. 配置 peer0.org2.example.com

**步骤6.1.** 新建"peer0.org2.example.com"文件夹，并复制替换msp, tls。

```shell
~/fabric-samples$ cp -rf peer0.org1.example.com/ peer0.org2.example.com/
~/fabric-samples$ rm -rf peer0.org2.example.com/msp/
~/fabric-samples$ rm -rf peer0.org2.example.com/tls/
~/fabric-samples$ cp -rf certs/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/*  peer0.org2.example.com/
```

**步骤6.2.** 修改core.yaml。

```shell
~/fabric-samples$ sed -i "s/peer0.org1.example.com/peer0\.org2\.example.com/g" peer0.org2.example.com/core.yaml
```

**步骤6.3.** 修改core.yaml。

```shell
~/fabric-samples$ sed -i "s/Org1MSP/Org2MSP/g" peer0.org2.example.com/core.yaml
```





<br />
<br />

## 7. 部署Orderer

**步骤7.1.** 创建/opt/app/fabric/orderer目录。
```shell
~/fabric-samples$ sudo mkdir -p /opt/app/fabric/orderer
```

**步骤7.2.** 复制配置文件到/opt/app/fabric/order目录。
```shell
~/fabric-samples$ sudo cp -r orderer.example.com/* /opt/app/fabric/orderer/
```




<br />
<br />

## 8. 部署 peer0.org1.example.com

**步骤8.1.** 创建/opt/app/fabric/peer目录。
```shell
~/fabric-samples$ sudo mkdir -p /opt/app/fabric/peer
```

**步骤8.2.** 复制配置文件到/opt/app/fabric/peer目录。
```shell
~/fabric-samples$ sudo cp -r peer0.org1.example.com/* /opt/app/fabric/peer/
```







<br />
<br />

## 10. 部署 peer0.org2.example.com

**步骤10.1.** 创建/opt/app/fabric/peer目录。

ubuntu01上，
```shell
~/fabric-samples$ sudo mkdir -p /opt/app/fabric/peer
```

**步骤10.2.** 复制配置文件到/opt/app/fabric/peer目录。

ubuntu00上，
```shell
~/fabric-samples$ scp -r peer0.org2.example.com joe@192.168.0.106:/tmp/
```

ubuntu01上，
```shell
$ sudo cp -r /tmp/peer0.org2.example.com/* /opt/app/fabric/peer/
```





<br />
<br />

## 11. 部署创世块和锚点
**步骤11.1.** 复制configtx.yaml文件
```shell
~/fabric-samples$ vi configtx.yaml
```


```yaml
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
 
---
################################################################################
#
#   Section: Organizations
#
#   - This section defines the different organizational identities which will
#   be referenced later in the configuration.
#
################################################################################
Organizations:
 
    # SampleOrg defines an MSP using the sampleconfig.  It should never be used
    # in production but may be used as a template for other definitions
    - &OrdererOrg
        # DefaultOrg defines the organization which is used in the sampleconfig
        # of the fabric.git development environment
        Name: OrdererOrg
 
        # ID to load the MSP definition as
        ID: OrdererMSP
 
        # MSPDir is the filesystem path which contains the MSP configuration
        MSPDir: ./certs/ordererOrganizations/example.com/msp
 
        # Policies defines the set of policies at this level of the config tree
        # For organization policies, their canonical path is usually
        #   /Channel/<Application|Orderer>/<OrgName>/<PolicyName>
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('OrdererMSP.member')"
            Writers:
                Type: Signature
                Rule: "OR('OrdererMSP.member')"
            Admins:
                Type: Signature
                Rule: "OR('OrdererMSP.admin')"
 
    - &Org1
        # DefaultOrg defines the organization which is used in the sampleconfig
        # of the fabric.git development environment
        Name: Org1MSP
 
        # ID to load the MSP definition as
        ID: Org1MSP
 
        MSPDir: ./certs/peerOrganizations/org1.example.com/msp
 
        # Policies defines the set of policies at this level of the config tree
        # For organization policies, their canonical path is usually
        #   /Channel/<Application|Orderer>/<OrgName>/<PolicyName>
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('Org1MSP.admin', 'Org1MSP.peer', 'Org1MSP.client')"
            Writers:
                Type: Signature
                Rule: "OR('Org1MSP.admin', 'Org1MSP.client')"
            Admins:
                Type: Signature
                Rule: "OR('Org1MSP.admin')"
 
        AnchorPeers:
            # AnchorPeers defines the location of peers which can be used
            # for cross org gossip communication.  Note, this value is only
            # encoded in the genesis block in the Application section context
            - Host: peer0.org1.example.com
              Port: 7051
 
    - &Org2
        # DefaultOrg defines the organization which is used in the sampleconfig
        # of the fabric.git development environment
        Name: Org2MSP
 
        # ID to load the MSP definition as
        ID: Org2MSP
 
        MSPDir: ./certs/peerOrganizations/org2.example.com/msp
 
        # Policies defines the set of policies at this level of the config tree
        # For organization policies, their canonical path is usually
        #   /Channel/<Application|Orderer>/<OrgName>/<PolicyName>
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('Org2MSP.admin', 'Org2MSP.peer', 'Org2MSP.client')"
            Writers:
                Type: Signature
                Rule: "OR('Org2MSP.admin', 'Org2MSP.client')"
            Admins:
                Type: Signature
                Rule: "OR('Org2MSP.admin')"
 
        AnchorPeers:
            # AnchorPeers defines the location of peers which can be used
            # for cross org gossip communication.  Note, this value is only
            # encoded in the genesis block in the Application section context
            - Host: peer0.org2.example.com
              Port: 7051
 
################################################################################
#
#   SECTION: Capabilities
#
#   - This section defines the capabilities of fabric network. This is a new
#   concept as of v1.1.0 and should not be utilized in mixed networks with
#   v1.0.x peers and orderers.  Capabilities define features which must be
#   present in a fabric binary for that binary to safely participate in the
#   fabric network.  For instance, if a new MSP type is added, newer binaries
#   might recognize and validate the signatures from this type, while older
#   binaries without this support would be unable to validate those
#   transactions.  This could lead to different versions of the fabric binaries
#   having different world states.  Instead, defining a capability for a channel
#   informs those binaries without this capability that they must cease
#   processing transactions until they have been upgraded.  For v1.0.x if any
#   capabilities are defined (including a map with all capabilities turned off)
#   then the v1.0.x peer will deliberately crash.
#
################################################################################
Capabilities:
    # Channel capabilities apply to both the orderers and the peers and must be
    # supported by both.  Set the value of the capability to true to require it.
    Global: &ChannelCapabilities
        # V1.1 for Global is a catchall flag for behavior which has been
        # determined to be desired for all orderers and peers running v1.0.x,
        # but the modification of which would cause incompatibilities.  Users
        # should leave this flag set to true.
        V1_1: true
 
    # Orderer capabilities apply only to the orderers, and may be safely
    # manipulated without concern for upgrading peers.  Set the value of the
    # capability to true to require it.
    Orderer: &OrdererCapabilities
        # V1.1 for Order is a catchall flag for behavior which has been
        # determined to be desired for all orderers running v1.0.x, but the
        # modification of which  would cause incompatibilities.  Users should
        # leave this flag set to true.
        V1_1: true
 
    # Application capabilities apply only to the peer network, and may be safely
    # manipulated without concern for upgrading orderers.  Set the value of the
    # capability to true to require it.
    Application: &ApplicationCapabilities
        # V1.1 for Application is a catchall flag for behavior which has been
        # determined to be desired for all peers running v1.0.x, but the
        # modification of which would cause incompatibilities.  Users should
        # leave this flag set to true.
        V1_2: true
 
################################################################################
#
#   SECTION: Application
#
#   - This section defines the values to encode into a config transaction or
#   genesis block for application related parameters
#
################################################################################
Application: &ApplicationDefaults
 
    # Organizations is the list of orgs which are defined as participants on
    # the application side of the network
    Organizations:
 
    # Policies defines the set of policies at this level of the config tree
    # For Application policies, their canonical path is
    #   /Channel/Application/<PolicyName>
    Policies:
        Readers:
            Type: ImplicitMeta
            Rule: "ANY Readers"
        Writers:
            Type: ImplicitMeta
            Rule: "ANY Writers"
        Admins:
            Type: ImplicitMeta
            Rule: "MAJORITY Admins"
 
    # Capabilities describes the application level capabilities, see the
    # dedicated Capabilities section elsewhere in this file for a full
    # description
    Capabilities:
        <<: *ApplicationCapabilities
 
################################################################################
#
#   SECTION: Orderer
#
#   - This section defines the values to encode into a config transaction or
#   genesis block for orderer related parameters
#
################################################################################
Orderer: &OrdererDefaults
 
    # Orderer Type: The orderer implementation to start
    # Available types are "solo" and "kafka"
    # OrdererType: kafka
    OrdererType: solo
 
    Addresses:
        - 127.0.0.1:7050
        # - orderer0.example.com:7050
        # - orderer1.example.com:7050
        # - orderer2.example.com:7050
 
    # Batch Timeout: The amount of time to wait before creating a batch
    BatchTimeout: 2s
 
    # Batch Size: Controls the number of messages batched into a block
    BatchSize:
 
        # Max Message Count: The maximum number of messages to permit in a batch
        MaxMessageCount: 10
 
        # Absolute Max Bytes: The absolute maximum number of bytes allowed for
        # the serialized messages in a batch.
        AbsoluteMaxBytes: 98 MB
 
        # Preferred Max Bytes: The preferred maximum number of bytes allowed for
        # the serialized messages in a batch. A message larger than the preferred
        # max bytes will result in a batch larger than preferred max bytes.
        PreferredMaxBytes: 512 KB
 
    Kafka:
        # Brokers: A list of Kafka brokers to which the orderer connects. Edit
        # this list to identify the brokers of the ordering service.
        # NOTE: Use IP:port notation.
        Brokers:
            - kafka0:9092
            - kafka1:9092
            - kafka2:9092
            # - kafka3:9092
 
    # Organizations is the list of orgs which are defined as participants on
    # the orderer side of the network
    Organizations:
 
    # Policies defines the set of policies at this level of the config tree
    # For Orderer policies, their canonical path is
    #   /Channel/Orderer/<PolicyName>
    Policies:
        Readers:
            Type: ImplicitMeta
            Rule: "ANY Readers"
        Writers:
            Type: ImplicitMeta
            Rule: "ANY Writers"
        Admins:
            Type: ImplicitMeta
            Rule: "MAJORITY Admins"
        # BlockValidation specifies what signatures must be included in the block
        # from the orderer for the peer to validate it.
        BlockValidation:
            Type: ImplicitMeta
            Rule: "ANY Writers"
 
    # Capabilities describes the orderer level capabilities, see the
    # dedicated Capabilities section elsewhere in this file for a full
    # description
    Capabilities:
        <<: *OrdererCapabilities
 
################################################################################
#
#   CHANNEL
#
#   This section defines the values to encode into a config transaction or
#   genesis block for channel related parameters.
#
################################################################################
Channel: &ChannelDefaults
    # Policies defines the set of policies at this level of the config tree
    # For Channel policies, their canonical path is
    #   /Channel/<PolicyName>
    Policies:
        # Who may invoke the 'Deliver' API
        Readers:
            Type: ImplicitMeta
            Rule: "ANY Readers"
        # Who may invoke the 'Broadcast' API
        Writers:
            Type: ImplicitMeta
            Rule: "ANY Writers"
        # By default, who may modify elements at this config level
        Admins:
            Type: ImplicitMeta
            Rule: "MAJORITY Admins"
 
 
    # Capabilities describes the channel level capabilities, see the
    # dedicated Capabilities section elsewhere in this file for a full
    # description
    Capabilities:
        <<: *ChannelCapabilities
 
################################################################################
#
#   Profile
#
#   - Different configuration profiles may be encoded here to be specified
#   as parameters to the configtxgen tool
#
################################################################################
Profiles:
 
    TwoOrgsOrdererGenesis:
        <<: *ChannelDefaults
        Orderer:
            <<: *OrdererDefaults
            Organizations:
                - *OrdererOrg
        Consortiums:
            SampleConsortium:
                Organizations:
                    - *Org1
                    - *Org2
 
    TwoOrgsChannel:
        Consortium: SampleConsortium
        Application:
            <<: *ApplicationDefaults
            Organizations:
                - *Org1
                - *Org2
```

**步骤11.2** 生成创世块和锚点配置
```shell
./bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./genesisblock
```

**步骤11.4.** 复制创世块和锚点到Orderer。
```shell
~/fabric-samples$ sudo cp genesisblock /opt/app/fabric/orderer/
```


<br />
<br />

## 12. 启动Hyperledger

ubuntu00启动orderer。
```shell
$ cd /opt/app/fabric/orderer
$ sudo ./orderer
```

ububtu00启动 peer0.org1.example.com。

```shell
$ cd /opt/app/fabric/peer
$ sudo ./peer node start 
```

ubuntu01启动 peer0.org2.example.com。

```shell
$ cd /opt/app/fabric/peer
$ sudo ./peer node start 
```





参考资料: https://jicki.me/fabric,kubernetes/2019/01/21/hyperledger-fabric-1.4-to-k8s/
