<script>
  import { onMount } from 'svelte';
  import Chart from 'chart.js/auto';
  import umpdViolentCrime from '../store/umpd/umpd_violent.json';
  import umpdPropertyCrime from '../store/umpd/umpd_property.json';
  
  let umpdViolentChart, umpdPropertyChart;

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
      const umpdHomicide = document.getElementById('umpdViolentChart').getContext('2d');
      umpdViolentChart = createChart(umpdHomicide, umpdViolentCrime, 'Violent Crimes');

      const umpdProperty = document.getElementById('umpdPropertyChart').getContext('2d');
      umpdPropertyChart = createChart(umpdProperty, umpdPropertyCrime, 'Property Crimes');
  });
</script>
  
  <h3>University of Minnesota Police Department</h3>
  
  <h4 class="source">Data sources: FBI</h4>
  
  <div><p>UMPD patrols the University of Minnesota, Twin Cities campuses and coordinates with MPD in the University neighborhoods.</p></div>
  
  <div class="chart-container">
    <canvas id="umpdViolentChart"></canvas>
  </div>
  <div class="download"><a href="../store/umpd/umpd_violent_historical.csv">Download UMPD 1985-2022 violent crimes data (includes clearances)</a></div>

  <p>&nbsp;</p>

  <p>Campus property crime rates have been declining for years.</p>

  <div class="chart-container">
    <canvas id="umpdPropertyChart"></canvas>
  </div>
  <div class="download"><a href="../store/umpd/umpd_property_historical.csv">Download UMPD 1985-2022 property crimes data (includes clearances)</a></div>
  
  
  
  <h4>Links</h4>
  <ul>
    <li><a href="https://publicsafety.umn.edu/">UMN Department of Public Safety</a></li>
    <li><a href="https://dps-dashboard.umn.edu/dashboard/">UMPD Incidents Dashboard</a></li>
  </ul>
  
  <style>
   
  </style>