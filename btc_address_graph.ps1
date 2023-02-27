# Define the Bitquery API endpoint and query
$BITQUERY_API_ENDPOINT = 'https://graphql.bitquery.io/'
$BITCOIN_NETWORK = 'bitcoin'
$BITQUERY_API_KEY = 'your_api_key'
$BITQUERY_API_QUERY = '
    query ($address: [String!]!) {
        bitcoin {
            transactions(
                input: { address: { in: $address } }
                output: { address: { notin: $address } }
            ) {
                hash
                inputs {
                    address
                }
                outputs {
                    address
                    value
                }
            }
        }
    }
'

# Define the Bitcoin addresses to scan
$ADDRESSES = @('address_1', 'address_2', 'address_3')

# Execute the Bitquery API query
$body = @{
    query = $BITQUERY_API_QUERY
    variables = @{ address = $ADDRESSES }
    apikey = $BITQUERY_API_KEY
}
$response = Invoke-RestMethod -Method Post -Uri $BITQUERY_API_ENDPOINT -Body ($body | ConvertTo-Json)

# Parse the response data and create a graph
$graph = New-Object 'System.Collections.Generic.List[PSObject]'
$transactions = $response.data.bitcoin.transactions
foreach ($tx in $transactions) {
    foreach ($input_ in $tx.inputs) {
        foreach ($output in $tx.outputs) {
            if ($ADDRESSES.Contains($input_.address) -and $ADDRESSES.Contains($output.address)) {
                $edge = New-Object PSObject -Property @{
                    Source = $input_.address
                    Target = $output.address
                    Weight = $output.value
                }
                $graph.Add($edge) | Out-Null
            }
        }
    }
}

# Generate the graph visualization
$dot = @"
graph G {
    rankdir = LR
    edge [fontname="Calibri", fontsize=9, penwidth=2]
    node [fontname="Calibri", fontsize=11, width=0.5, height=0.5, fixedsize=true, style=filled, penwidth=2]

    # Add nodes
    $($ADDRESSES | ForEach-Object { "$_ [label=""$_"", color=skyblue, fontsize=11, shape=circle, width=`"$($_.balance/1e8*0.1)`", height=`"$($_.balance/1e8*0.1)`", fillcolor=skyblue, style=filled]" })

    # Add edges
    $($graph | ForEach-Object { "$($_.Source) -- $($_.Target) [penwidth=`"$($_.Weight/1e8*2)`", label=`"$($_.Weight)`"]" })
}
"@
$graphviz = "C:\Program Files\Graphviz\bin\dot.exe"
$outputFile = "btc_address_graph.png"
& $graphviz -Tpng -o$outputFile -Kneato -Gstart=rand $dot
