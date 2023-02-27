This PowerShell script uses the Bitquery API to scan Bitcoin addresses, identify any links between them, generate a graph showing the links, and export the graph as a PNG image file. The script requires the following:

Windows (or other Graphviz-supported operating system)
Graphviz
Bitquery API key
Bitcoin addresses to scan
Installation
Download and install Graphviz from the official Graphviz website: http://www.graphviz.org.
Sign up for a Bitquery account and obtain an API key from the Bitquery dashboard.
Usage
Download the script to your local machine.

Open Windows PowerShell.

Navigate to the directory where the script is saved.

Modify the $ADDRESSES and $BITQUERY_API_KEY variables in the script to specify the Bitcoin addresses that you want to scan and your actual Bitquery API key, respectively.

Modify the $graphviz variable in the script to point to the location of the dot.exe file on your system.

Run the script by executing the following command:

Copy code
.\btc_address_graph.ps1
The script will retrieve data on Bitcoin transactions involving the specified addresses, identify any links between the addresses, generate a graph showing the links, and save the graph as a PNG image file named btc_address_graph.png in the same directory as the script.
