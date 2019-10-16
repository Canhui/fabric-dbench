ORGS=3
COMMANDS="invoke_and_all_orgs.sh"
THREADS=30
SECS_PER_THREADS=1

rm -rf /home/t716/fabric-dbench/workload-generator/src/run_bench.java

cat>/home/t716/fabric-dbench/workload-generator/src/run_bench.java<<EOF
import java.util.concurrent.CountDownLatch;
//import java.io.*;
public class run_bench {
 
	public static void main(String[] args) throws InterruptedException {
		int THREADS=$THREADS; // # of clients
		int SECS_PER_THREADS=$SECS_PER_THREADS; // 1 second per 50 threads  
		int DURATIONS=25; // duration of test
		
		CountDownLatch countDownLatch = new CountDownLatch(THREADS);
		//for(int i=0; i<DURATIONS; i++) {
			long start_time = System.currentTimeMillis();
            for (int j=0; j<THREADS; j++) {
				Thread thread = new Thread(new benchmark(countDownLatch));
				//String threadname = String.format("Thread Group: %d, Thread Id: %d",i ,j+1);
                String threadname = String.format("Thread Group: %d, Thread Id: %d",0 ,j+1);
				thread.setName(threadname);
				thread.start();
				countDownLatch.countDown();
			}
            long end_time = System.currentTimeMillis();
            System.out.println("Time used to create threads:"+(end_time-start_time)/1000);
			//Thread.sleep(1000*SECS_PER_THREADS-(end_time-start_time));
		//}
		
	}
	
}
class benchmark implements Runnable {
 
	private final CountDownLatch countDownLatch;
	
	public benchmark(CountDownLatch countDownLatch) {
		this.countDownLatch = countDownLatch;
	}
	public void Invoke() {
		Process proc = null;
        try {
            String command = "/home/t716/fabric-dbench/fabric-samples/sdk.org1.example.com/$COMMANDS";
	        //String command = "/home/t716/fabric-dbench/multi-threads/run.sh";
	        proc = Runtime.getRuntime().exec(new String[] { "/bin/sh", "-c", command });
	        if (proc != null) {
	            proc.waitFor();
	        }
	    } catch (Exception e) {
	        return;
	    }
	}	
	@Override
	public void run() {
		try {
			countDownLatch.await();
            //System.out.println("Start Time:"+System.currentTimeMillis()/1000);
			this.Invoke();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
	
}
EOF





echo "------------------------------------------------------------"
echo "Copy Bench Files to All Peers"
echo "------------------------------------------------------------"
for ((i=2;i<=$ORGS;i++))
do
    mkdir -p /home/t716/fabric-dbench/workload-generator/tmp/bench$i
    cp -rf /home/t716/fabric-dbench/workload-generator/src/* /home/t716/fabric-dbench/workload-generator/tmp/bench$i
    sed -i "s/org1/org$i/g" /home/t716/fabric-dbench/workload-generator/tmp/bench$i/run_bench.java
done





# copy bench files to each remote peer
for ((i=2;i<=$ORGS;i++))
do
    ssh t716@peer0.org$i.example.com "echo [T716rrs722] | sudo rm -rf $HOME/fabric-dbench/workload-generator"
    ssh t716@peer0.org$i.example.com "echo [T716rrs722] | mkdir -p $HOME/fabric-dbench/workload-generator/src"
done

for ((i=2;i<=$ORGS;i++))
do
    scp -r $HOME/fabric-dbench/workload-generator/tmp/bench$i/run_bench.java t716@peer0.org$i.example.com:/home/t716/fabric-dbench/workload-generator/src
done
