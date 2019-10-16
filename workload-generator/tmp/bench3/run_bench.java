import java.util.concurrent.CountDownLatch;
//import java.io.*;


public class run_bench {
 
	public static void main(String[] args) throws InterruptedException {
		int THREADS=30; // # of clients
		int SECS_PER_THREADS=1; // 1 second per 50 threads  
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
            String command = "/home/t716/fabric-dbench/fabric-samples/sdk.org3.example.com/invoke_and_all_orgs.sh";
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
