<script>
    import { onMount } from 'svelte';
    import Chart from 'chart.js/auto';
    import stpProperty from '../../store/stpl/stp_larceny.json';
  
    let propertyChart;

    function createChart(ctx, chartData, title, type = 'line') {
        return new Chart(ctx, {
        type: type,
        data: {
            labels: chartData.map(item => item.year.toString()),
            datasets: [{
            label: title,
            data: chartData.map(item => item.incidents), 
            backgroundColor: 'rgba(70, 130, 180, 0.8)',
            borderColor: 'rgba(70, 130, 180, 1)',
            borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
            y: {
                beginAtZero: true,
                title: {
                display: true,
                text: ' '
                }
            }
            }
        }
        });
    }

    onMount(() => {
        const ctxProperty = document.getElementById('propertyChart').getContext('2d');
        propertyChart = createChart(ctxProperty, stpProperty, 'Larceny');
    });
  </script>

<h3>St. Paul: Larceny</h3>

<h4 class="source">Data sources: FBI</h4>

<p>Larcenies in St. Paul have fallen over time.</p>

<div class="chart-container">
    <canvas id="propertyChart"></canvas>
  </div>
<div class="download"><a href="../store/stpl/stp_larceny.csv">Download St. Paul 1985-2023 larcenies data (includes clearances)</a></div>

<h4>Links</h4>


<ul>
    <li><a href="https://information.stpaul.gov/apps/1b00c40c873748e6a42dd9ba9e9f533b/explore">SPPD Crime Data Export Tool</a></li>
    <li><a href="https://information.stpaul.gov/datasets/stpaul::crime-incident-report/explore">SPPD Crime Incident Reports</a></li>
    <li><a href="https://information.stpaul.gov/apps/crime-incidents-by-neighborhood/explore">SPPD Police Incidents</a></li>
    <li><a href="https://saintpaulmn.mycusthelp.com/WEBAPP/_rs/(S(3bgsui0ryccasua2zoohdy5k))/supporthome.aspx">St. Paul DPA requests</a></li>
</ul>

<style>

</style>
