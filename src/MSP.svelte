<script>
  import { onMount } from 'svelte';
  import Chart from 'chart.js/auto';
  import apdViolentCrime from '../store/msp/apd_violent.json';
  import apdPropertyCrime from '../store/msp/apd_property.json';
  
  let apdViolentChart, apdPropertyChart;

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
      const apdHomicide = document.getElementById('apdViolentChart').getContext('2d');
      apdViolentChart = createChart(apdHomicide, apdViolentCrime, 'Violent Crimes');

      const apdProperty = document.getElementById('apdPropertyChart').getContext('2d');
      apdPropertyChart = createChart(apdProperty, apdPropertyCrime, 'Property Crimes');
  });
</script>


<h3>Minneapolis-St. Paul International Airport Police Department</h3>

<h4 class="source">Data sources: FBI</h4>

<div><p>Formed in 1947, the MSP Airport Police Department (APD) patrols the airport. Historical data is available with each new Uniform Crime Report release.</p></div>

  
<div class="chart-container">
  <canvas id="apdViolentChart"></canvas>
</div>
<div class="download"><a href="../store/msp/apd_violent.csv">Download APD 1985-2022 violent crimes data (includes clearances)</a></div>

<p>&nbsp;</p>

<p>MSP property crime rates are lower than three decades ago.</p>
<div class="chart-container">
  <canvas id="apdPropertyChart"></canvas>
</div>
<div class="download"><a href="../store/msp/apd_property.csv">Download APD 1985-2022 property crimes data (includes clearances)</a></div>

<p>&nbsp;</p>

<h4>Links</h4>
<ul>
  <li><a href="https://www.mspairport.com/public-safety/airport-police-department">About the MSP Airport Police Department</a></li>
</ul>

<style>
 
</style>