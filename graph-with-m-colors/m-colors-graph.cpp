#include<iostream>
#include <algorithm>
using namespace std;

//全局参数
int n,k,m,sum;//图点数、边数、着色数、总共着色的方案数
bool paint[50];
int pic[50][50],node[50];

bool Judge(int x,int j)
{ //判断
    for(int i=1; i<=n; i++)
    {
        //判断：如果与它相连并且与它将要涂的颜色一样
        if(pic[x][i] && node[i]==j)
            return 0;//假
    }
    return 1;//真
}

void search(int x)
{//他的情况不是能涂哪个节点，因为我们就是从第一个开始涂色的，而是有m个颜色可涂；
    if(x>n)
    {
        sum++;
        for (int i = 1;i<=n;i++)
            cout<<node[i]<<" ";
        cout<<endl;
    }
    else
        for(int i = 1; i<=m; i++) { //每一个有1-m种情况可以涂
            if(Judge(x,i))
            {
                //第x个涂第i个颜色，这里记录的原因是为判断一个点和他相邻的点是否一个颜色
                node[x]=i;
                search(x+1);//迭代
                node[x]=0;//回溯
            }
        }
}


int main() {
    int x,y;
    cout<<"请分别输入图的点数、边数、着色颜色数：\n";
    cin>>n>>k>>m;
    cout<<"分别输入相邻边编号：\n";
    for(int i=1; i<=k; i++) {
        cin>>x>>y;
        pic[x][y] = pic[y][x] = 1;//初始化
    }
    cout<<"---------------------\n";
    search(1);
    cout<<"着色方案有以上"<<sum<<"种方式：\n";
    return 0;
}
