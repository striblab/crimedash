<script>
    import { onMount } from 'svelte';
    import Chart from 'chart.js/auto';
    import stpHomicideRate from '../public/stp/stp_homicide_rate.json';
    import stpProperty from '../public/stp/stp_property.json';
    import stpViolentCrime from '../public/stp/stp_violent.json';
  
    let homicideChart, propertyChart, violentCrimeChart;

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
                text: 'Incidents'
                }
            }
            }
        }
        });
    }

    onMount(() => {
        const ctxHomicide = document.getElementById('homicideChart').getContext('2d');
        homicideChart = createChart(ctxHomicide, stpHomicideRate, 'Homicide Rate');

        const ctxProperty = document.getElementById('propertyChart').getContext('2d');
        propertyChart = createChart(ctxProperty, stpProperty, 'Property Crimes');

        const ctxViolent = document.getElementById('violentCrimeChart').getContext('2d');
        violentCrimeChart = createChart(ctxViolent, stpViolentCrime, 'Violent Crimes');
    });
  </script>

<h3>St. Paul Public Safety Trends</h3>

<p>As with many other American cities, homicide rates in St. Paul increased in 2020, though had been climbing somewhat before that. In 2023, the rate dropped for the first time in five years.</p>

<div class="chart-container">
    <canvas id="homicideChart"></canvas>
  </div>
<div class="download"><a href="public/stp/stp_homicide_rate.csv">Download St. Paul 1976-2023 homicide data</a></div>

<p>&nbsp;</p>

<p>Violent crime rates per 100,000 residents in St. Paul have been flatter over time, and rose significantly starting in 2020. Violent crimes include murder, aggravated assault, rape and robbery.</p>

<div class="chart-container">
    <canvas id="violentCrimeChart"></canvas>
  </div>
<div class="download"><a href="public/stp/stp_violent.csv">Download St. Paul 1985-2022 violent crimes data (includes clearances)</a></div>

<p>&nbsp;</p>

<p>Property crime rates per 100,000 residents in St. Paul have fallen over time, and rose significantly starting in 2020, driven primarily by auto thefts. Property crimes include vehicular theft, burglary, larceny and arson.</p>

<div class="chart-container">
    <canvas id="propertyChart"></canvas>
  </div>
<div class="download"><a href="public/stp/stp_property.csv">Download St. Paul 1985-2022 property crimes data (includes clearances)</a></div>

<p>&nbsp;</p>

<h4>Links</h4>
<ul>
    <li><a href="https://information.stpaul.gov/apps/crime-incidents-by-neighborhood/explore">SPPD Police Incidents</a></li>
    <li><a href="https://docs.google.com/spreadsheets/d/1dGId7vn3iwESAXkVbNY58lP0-u10qh5qvFx6HE4HUAM/edit#gid=0">Star Tribune: St. Paul homicides spreadsheet</a></li>
    <li><a href="https://saintpaulmn.mycusthelp.com/WEBAPP/_rs/(S(3bgsui0ryccasua2zoohdy5k))/supporthome.aspx">St. Paul DPA requests</a></li>
</ul>

<style>
  .chart-container {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-around;
    padding: 20px;
  }
  canvas {
    max-width: 100%;
    height: 300px !important;
  }
</style>
