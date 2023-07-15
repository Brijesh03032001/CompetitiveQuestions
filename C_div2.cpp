#include<bits/stdc++.h>
using namespace std;int T,n,s,x,ans;bool cnt[256];int main(){for(scanf("%d",&T);T--;){scanf("%d",&n),s=ans=0,memset(cnt,0,sizeof(cnt)),cnt[0]=1;for(int i=1;i<=n;++i){scanf("%d",&x),s^=x;for(int j=0;j<256;++j)if(cnt[j])ans=max(ans,s^j);cnt[s]=1;}printf("%d\n",ans);}return 0;}
