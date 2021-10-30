import java.util.*;
import java.io.*;

public class ChangeNegativesToZero{
	
	public static void main(String[] args) throws IOException{
		BufferedReader br = new BufferedReader(new FileReader("ROICorrelation_FisherZ_sub_600460215379.txt"));
		PrintWriter pw = new PrintWriter("ROICorrelation_FisherZ_sub_600460215379_mod.txt");


		for(int i = 0; i < 116; i++){
			String[] l = br.readLine().trim().split("\\s+");
			for(int j = 0; j < 116; j++){
				if(i == j){
					pw.print("INF ");
					continue;
				}
				// System.out.println("l[j]: " + l[j]);
				double z = Double.parseDouble(l[j]);
				z = Math.max(0, z);
				pw.print(z + " ");
			}
			pw.println();
		}

		pw.close();
	}

}