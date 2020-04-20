// C++ program to illustrate 
// Vizing's Theorem 
#include <iostream> 
using namespace std; 
  
// Function to print the color of the edge 
void colorEdge(int edg[][3], int e) 
{ 
    int color; 
  
    // Assign a color to every edge 'i'. 
    for (int i = 0; i < e; i++) { 
        color = 1; 
    flag: 
        // Assign a color and 
        // then check its validity. 
        edg[i][2] = color; 
        for (int j = 0; j < e; j++) { 
            if (j == i) 
                continue; 
  
            // If the color of edges 
            // is adjacent to edge i 
            if ((edg[i][0] == edg[j][0])||  
               (edg[i][1] == edg[j][0]) ||  
               (edg[i][0] == edg[j][1]) ||  
               (edg[i][1] == edg[j][1])) { 
  
                // If the color matches 
                if (edg[i][2] == edg[j][2]) { 
  
                    // Increment the color, 
                    // denotes the change in color. 
                    color++; 
  
                    // goes back, and assigns 
                    // the next color. 
                    goto flag; 
                } 
            } 
        } 
    } 
} 
  
// Function to assign Degree 
void degree(int v, int e, int edg[][3]) 
{ 
    int maximum = -1; 
    int Deg[v + 1] = { 0 }; 
  
    for (int i = 0; i < e; i++) { 
        Deg[edg[i][0]]++; 
        Deg[edg[i][1]]++; 
    } 
  
    // To find the maximum degree. 
    for (int i = 1; i <= v; i++) { 
        if (maximum < Deg[i]) 
            maximum = Deg[i]; 
    } 
  
    // color the edges of the graph. 
    colorEdge(edg, e); 
    cout << maximum + 1 << " colors needs to generate"
         << " a valid edge coloring :\n"; 
  
    for (int i = 0; i < e; i++) 
        cout << "\ncolor between v(1): " << edg[i][0] << " and v(2): "
             << edg[i][1] << " is: color " << edg[i][2]; 
} 
  
// Driver Code 
int main() 
{ 
  
    // initialize the number 
    // of vertexes of the graph 
    int v = 4; 
    // initialize the number 
    // of edges of the graph 
    int e = 5; 
  
    // initialize the vertex 
    // pair of every edge in a graph 
    int edg[e][3] = { { 1, 2, -1 }, 
                      { 2, 3, -1 }, 
                      { 3, 4, -1 }, 
                      { 4, 1, -1 }, 
                      { 1, 3, -1 } }; 
  
    degree(v, e, edg); 
    return 0; 
} 