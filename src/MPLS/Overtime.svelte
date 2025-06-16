<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
  
    import Chart from 'chart.js/auto';
  
    import overtimeYear from '../data/overtime.json';
  
    // Store to track the active image for the lightbox
    let activeImage = writable(null);
  
    function openLightbox(image) {
      activeImage.set(image);
    }
  
    function closeLightbox() {
      activeImage.set(null);
    }
  
    let amonthlyChart;
    let resizeTimer;
  
    function createChart(ctx, chartData, title, type = 'bar') {
      return new Chart(ctx, {
        type: type,
        data: {
          labels: chartData.labels,
          datasets: chartData.datasets
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: {
              beginAtZero: true
            }
          }
        }
      });
    }
  
    function handleResize() {
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(() => {
        amonthlyChart.resize();
        ayearlyChart.resize();
        aytdChart.resize();
        aprecinctChart.resize();
      }, 250);
    }
  
  
    onMount(() => {
      window.addEventListener('resize', handleResize);
  
      // Prepare chart data
      const yearlyChartData = { labels: overtimeYear.map(item => item.year.toString()), datasets: [{ label: 'Overtime Paid', data: overtimeYear.map(item => item.incidents), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0.8)', borderWidth: 0 }] };
  
      yearlyChart = createChart(document.getElementById('yearlyChart').getContext('2d'), yearlyChartData, 'Overtime');

    });
  </script>
  
  
  <h3>Minneapolis: Overtime</h3>

  <h4 class="source">Data sources: Minneapolis Police Department</h4>
  
  <p>Minneapolis police have accrued record amounts of overtime since the pandemic, with 2024 reaching the highest levels yet.</p>
  
  
  <h4>Annual MPD overtime trend</h4>
  <div class="chart-container">
    <canvas id="yearlyChart"></canvas>
  </div>
  <div class="download"><a href="../store/overtime/overtime.csv">Download MPD overtime by year</a></div> 
  <div class="download"><a href="../store/overtime/mpd_overtime.xlsx">Download MPD overtime pay by year and category</a></div> 
  <div class="download"><a href="../store/overtime/mpd_pay_2024.xlsx">Download MPD paystub data, 2024</a></div> 

  <p>&nbsp;</p>
<h4>Links</h4>
<ul>
  <li><a href="https://minneapolismn.opengov.com/transparency#/35901/accountType=expenses&embed=n&breakdown=ee076d02-de82-4b3b-9f8e-4a4c99429caf&currentYearAmount=cumulative&currentYearPeriod=years&graph=bar&legendSort=desc&proration=true&saved_view=null&selection=B9BD966E8A45D655A16CB9FB03FE6CB2&projections=null&projectionType=null&highlighting=null&highlightingVariance=null&year=2025&selectedDataSetIndex=null&fiscal_start=earliest&fiscal_end=latest">Minneapolis Police Department overtime dashboard</a></li>
</ul>

  <style>
  
  </style>