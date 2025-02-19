<script>
    import { onMount } from 'svelte';
    import Chart from 'chart.js/auto';
    import stpHomicideRate from '../store/stpm/stp_homicide_rate.json';
  
    let homicideChart;

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
        const ctxHomicide = document.getElementById('homicideChart').getContext('2d');
        homicideChart = createChart(ctxHomicide, stpHomicideRate, 'Homicide Rate per 100,000 residents');
    });
  </script>

<h3>St. Paul: Homicides</h3>

<h4 class="source">Data sources: St. Paul Police Department, FBI</h4>

<p>As with many other American cities, homicide rates in St. Paul increased in 2020, though had been climbing somewhat before that. St. Paul's homicide rate has been dropping gradually in recent years.</p> 

<div class="def">The Star Tribune differentiates between murder rates and comprehensive homicide rates, since the latter also includes police-involved deaths, self-defense killings and manslaughters. The data provided for St. Paul is a homicide rate, but we may parse out the murder cases for spot coverage.</div>

<div class="chart-container">
    <canvas id="homicideChart"></canvas>
  </div>
<div class="download"><a href="../store/stpm/stp_homicide_rate.csv">Download St. Paul 1976-2023 homicide data</a></div>
<div class="download"><a href="../store/stpm/stp_homicides.xlsx">Download St. Paul FBI Supplementary Homicide Report, 1976-2023</a></div>

<h4>Links</h4>


<ul>
    <li><a href="https://information.stpaul.gov/apps/1b00c40c873748e6a42dd9ba9e9f533b/explore">SPPD Crime Data Export Tool</a></li>
    <li><a href="https://information.stpaul.gov/datasets/stpaul::crime-incident-report/explore">SPPD Crime Incident Reports</a></li>
    <li><a href="https://information.stpaul.gov/apps/crime-incidents-by-neighborhood/explore">SPPD Police Incidents</a></li>
    <li><a href="https://docs.google.com/spreadsheets/d/1dGId7vn3iwESAXkVbNY58lP0-u10qh5qvFx6HE4HUAM/edit#gid=0">Star Tribune: St. Paul homicides spreadsheet</a></li>
    <li><a href="https://saintpaulmn.mycusthelp.com/WEBAPP/_rs/(S(3bgsui0ryccasua2zoohdy5k))/supporthome.aspx">St. Paul DPA requests</a></li>
</ul>

<style>

</style>
