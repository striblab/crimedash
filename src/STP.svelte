<script>
    import { onMount } from 'svelte';
    import Chart from 'chart.js/auto';
    import stpHomicideRate from '../store/stp/stp_homicide_rate.json';
    import stpProperty from '../store/stp/stp_property.json';
    import stpViolentCrime from '../store/stp/stp_violent.json';
  
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

        const ctxProperty = document.getElementById('propertyChart').getContext('2d');
        propertyChart = createChart(ctxProperty, stpProperty, 'Property Crimes');

        const ctxViolent = document.getElementById('violentCrimeChart').getContext('2d');
        violentCrimeChart = createChart(ctxViolent, stpViolentCrime, 'Violent Crimes');
    });
  </script>

<h3>St. Paul: Public Safety Trends</h3>

<h4 class="source">Data sources: FBI</h4>

<p>As with many other American cities, homicide rates in St. Paul increased in 2020, though had been climbing somewhat before that. In 2023, the rate dropped for the first time in five years.</p>

<div class="chart-container">
    <canvas id="homicideChart"></canvas>
  </div>
<div class="download"><a href="../store/stp/stp_homicide_rate.csv">Download St. Paul 1976-2023 homicide data</a></div>
<div class="download"><a href="../store/stp/STPMNSHR65_22.csv.zip">Download St. Paul FBI Supplementary Homicide Report, 1976-2022</a></div>


<p>&nbsp;</p>

<p>Violent crime rates per 100,000 residents in St. Paul have been flatter over time, and rose significantly starting in 2020. In the UCR, violent crimes include murder, aggravated assault, rape and robbery.</p>

<div class="chart-container">
    <canvas id="violentCrimeChart"></canvas>
  </div>
<div class="download"><a href="../store/stp/stp_violent.csv">Download St. Paul 1985-2022 violent crimes data (includes clearances)</a></div>

<p>&nbsp;</p>

<p>Property crime rates per 100,000 residents in St. Paul have fallen over time, and rose significantly starting in 2020, driven primarily by auto thefts. In the UCR, property crimes include vehicular theft, burglary, larceny and arson.</p>

<div class="chart-container">
    <canvas id="propertyChart"></canvas>
  </div>
<div class="download"><a href="../store/stp/stp_property.csv">Download St. Paul 1985-2022 property crimes data (includes clearances)</a></div>

<h4>Links</h4>


<ul>
    <li><a href="https://information.stpaul.gov/datasets/stpaul::crime-incident-report/explore">SPPD Crime Incident Reports</a></li>
    <li><a href="https://information.stpaul.gov/apps/crime-incidents-by-neighborhood/explore">SPPD Police Incidents</a></li>
    <li><a href="https://docs.google.com/spreadsheets/d/1dGId7vn3iwESAXkVbNY58lP0-u10qh5qvFx6HE4HUAM/edit#gid=0">Star Tribune: St. Paul homicides spreadsheet</a></li>
    <li><a href="https://saintpaulmn.mycusthelp.com/WEBAPP/_rs/(S(3bgsui0ryccasua2zoohdy5k))/supporthome.aspx">St. Paul DPA requests</a></li>
</ul>

<style>

</style>
