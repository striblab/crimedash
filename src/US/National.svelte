<script>
    import { onMount } from 'svelte';
    import Chart from 'chart.js/auto';
    import usHomicideRate from '../../store/national/us_homicide.json';
    import usViolentCrime from '../../store/national/us_violence.json';
    import usClearance from '../../store/national/us_clearance.json';
    
    let ushomicideChart, usClearanceChart, usviolentCrimeChart;

    function createChart(ctx, chartData, title, type = 'line') {
        return new Chart(ctx, {
        type: type,
        data: {
            labels: chartData.map(item => item.year.toString()),
            datasets: [{
            label: title,
            data: chartData.map(item => item.rate), 
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
                text: 'Rate' 
                }
            }
            }
        }
        });
    }

    onMount(() => {
        const ctxHomicide = document.getElementById('ushomicideChart').getContext('2d');
        ushomicideChart = createChart(ctxHomicide, usHomicideRate, 'Homicide Rate per 100,000 people');

        const ctxProperty = document.getElementById('usClearanceChart').getContext('2d');
        usClearanceChart = createChart(ctxProperty, usClearance, 'Homicide Clearance Rate %');

        const ctxViolent = document.getElementById('usviolentCrimeChart').getContext('2d');
        usviolentCrimeChart = createChart(ctxViolent, usViolentCrime, 'Violent Crimes per 100,000 people');
    });
  </script>

<h3>National Trends</h3>

<h4 class="source">Data sources: FBI, Murder Accountability Project</h4>

<p>The national homicide rate per 100,000 residents jumped dramatically in 2020, but after prior decades of decline remains far below the peaks the early 1990s.</p>
<div class="chart-container">
    <canvas id="ushomicideChart"></canvas>
  </div>
  <div class="download"><a href="../store/national/fbi_national_homicide_rate.csv">Download national homicide rate data</a></div>
  <div class="download"><a href="../store/national/SHR65_23.csv.zip">Download national FBI Supplementary Homicide Report, 1965-2024</a></div>

<p>&nbsp;</p>

<p>The national homicide clearance rate has been plummeting for decades and hit all-time lows in the 2020s.</p>
<div class="chart-container">
    <canvas id="usClearanceChart"></canvas>
  </div>
  <div class="download"><a href="../store/national/us_clearance.csv">Download national homicide clearance rate data</a></div>

<p>&nbsp;</p>

<p>The national violent crime rate per 100,000 residents fell dramatically to 40-year lows and has remained flatter in recent years.</p>
<div class="chart-container">
    <canvas id="usviolentCrimeChart"></canvas>
  </div>
<div class="download"><a href="../store/national/fbi_national_violence_rate.csv">Download national violence rate data</a></div>

<p>&nbsp;</p>

<h4>Links</h4>
<ul>
    <li><a href="https://cde.ucr.cjis.gov/LATEST/webapp/#/pages/explorer/crime/crime-trend">FBI Crime Data Explorer</a></li>
    <li><a href="https://www.ojjdp.gov/ojstatbb/ezashr/asp/off_selection.asp">FBI Supplementary Homicide Reports</a></li>
    <li><a href="http://www.murderdata.org/">Murder Accountability Project</a></li>
    <li><a href="https://www.ahdatalytics.com/dashboards/ytd-murder-comparison/">City YTD murder statistics</a></li>
    <li><a href="https://wonder.cdc.gov/controller/datarequest/D176">CDC WONDER</a></li>
    <li><a href="https://www.gunviolencearchive.org/query/4c112967-14d3-41b1-871f-2c0dfa095f9b">Gun Violence Archive</a></li>
    <li><a href="https://datacommons.org/place/geoId/2758000">Demographic Data Commons</a></li>
</ul>


<style>

</style>
  