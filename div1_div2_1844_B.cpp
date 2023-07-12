#include<bits/stdc++.h>
using namespace std;
int main(){
    ios::sync_with_stdio(0);
    cin.tie(0);
    int t;
    cin>>t;
    for(int w=0;w<t;w++){
        int n,i;
        cin >> n;
        for(i=2;i<=n;i=i+2){
            cout << i << ' ';
        }
        cout << 1 << ' ';
        if(n%2==0){
            n=n-1;
        }
        for(i=n;i>1;i=i-2){
            cout << i << ' ';
        }
        cout << endl;
    }
}

// #include <bits/stdc++.h>
// using namespace std;
// int main() {
// 	int t;cin>>t;
// 	while(t--){
// 		int n;cin>>n;
// 		if(n==1) cout<<"1\n";
// 		else if(n==2) cout<<"2 1\n";
// 		else{
// 			vector<int> arr(n,0);
// 			arr[n/2] = 1;
// 			arr[n-1] = 3;
// 			arr[0] = 2;
// 			int x = 4;
// 			for(int j=0;j<n;j++) if(arr[j] == 0){
// 				arr[j] = x;
// 				x++;
// 			}
// 			for(auto it:arr) cout<<it<<" ";
// 			cout<<"\n";
// 		}
// 	}
// 	return 0;
// }