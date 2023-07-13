#include <bits/stdc++.h>
using namespace std;
#define gc getchar_unlocked
#define fo(i,n) for(i=0;i<n;i++)
#define Fo(i,k,n) for(i=k;k<n?i<n:i>n;k<n?i+=1:i-=1)
#define ll long long
#define si(x)	scanf("%d",&x)
#define sl(x)	scanf("%lld",&x)
#define ss(s)	scanf("%s",s)
#define pi(x)	printf("%d\n",x)
#define pl(x)	printf("%lld\n",x)
#define ps(s)	printf("%s\n",s)
#define pb push_back
#define mp make_pair
#define F first
#define S second
#define all(x) x.begin(), x.end()
#define clr(x) memset(x, 0, sizeof(x))
#define sortall(x) sort(all(x))
#define tr(it, a) for(auto it = a.begin(); it != a.end(); it++)
#define PI 3.1415926535897932384626
typedef pair<int, int>	pii;
typedef pair<ll, ll>	pl;
typedef vector<int>		vi;
typedef vector<ll>		vl;
typedef vector<pii>		vpii;
typedef vector<pl>		vpl;
typedef vector<vi>		vvi;
typedef vector<vl>		vvl;
int mpow(int base, int exp); 
void ipgraph(int m);
void dfs(int u, int par);
const int mod = 1000000007;
const int N = 3e5, M = N;
// void ans()
// {
// 	int n;
// 	cin>>n;
// 	vector<int>vc(n);
// 	int mini= INT_MAX;
// 	int maxi = INT_MIN;
// 	for(int i=0;i<n;i++)
// 	{
//         cin>>vc[i];
//         mini= min(mini, vc[i]);
//         maxi= max(maxi, vc[i]);
// 	}
//     if(mini!=0)
//     {
//     	cout<<"NO"<<"\n";
//     	return ;
//     }
//     unordered_map<int,int>mp;
//     for(int i=0;i<=maxi;i++)
//     {
// -       mp.insert({i, 0});
//     }

//     for(int i=0;i<n;i++)
//     {
//     	mp[vc[i]]++;
//     }

//     int pre=mp[0];
//     sort(mp.begin(),mp.end());
//     for(auto it : mp)
//     {
//     	if(it.first!=0) 
//     	{
//     		if(it.second > pre)
//     		{
//     			cout<<"NO"<<"\n";
//     			return;
//     		}
//     		else 
//     		{
//     			pre=it.second;
//     		}
//     	}

//     }
//     cout<<"YES"<<"\n";
//     return;
// }
void ans()
{
 
        int n, k, g;
        cin >> n >> k >> g;

        int base = (k * g + n / 2) / n; // base amount of silver coins assigned to each astrophysicist
        int remaining = k * g % n; // remaining silver coins

        int totalSavedCoins = 0;

        for (int i = 1; i <= n; i++) {
            if (remaining > 0) {
                // Assign an additional silver coin to the astrophysicist
           //     cout << (base + 1) << " ";
                remaining--;
            } else {
               // cout << base << " ";
            }

            totalSavedCoins += (base % g); // Calculate the remainder and add it to total saved coins
        }

        cout << totalSavedCoins<<endl;

}

int main()
{
	int t;
	cin>>t;
	while(t--)
	{
		ans();
	}
	return 0;
}