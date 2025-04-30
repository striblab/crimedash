<script>
  import { onMount } from 'svelte';
  import { writable } from 'svelte/store';

  import Chart from 'chart.js/auto';

  import justifiedMonthlyComparison from '../data/justified_monthly_comparison.json';
  import justifiedYearlyIncidentCounts from '../data/justified_yearly_incident_counts.json';
  import justifiedYTDComparison from '../data/justified_ytd_comparison.json';

  // Store to track the active image for the lightbox
  let activeImage = writable(null);

  function openLightbox(image) {
    activeImage.set(image);
  }

  function closeLightbox() {
    activeImage.set(null);
  }

  let monthlyChart, yearlyChart, ytdChart, precinctChart, historyChart;
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
      monthlyChart.resize();
      yearlyChart.resize();
      ytdChart.resize();
    }, 250);
  }

  onMount(() => {
    window.addEventListener('resize', handleResize);

    // Prepare chart data
    const monthlyChartData = { labels: justifiedMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly justifieds', data: justifiedMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0.8)', borderWidth: 1 }] };
    const yearlyChartData = { labels: justifiedYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly justifieds', data: justifiedYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0.8)', borderWidth: 0 }] };
    const ytdChartData = { labels: justifiedYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD justifieds', data: justifiedYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0.8)', borderWidth: 0}] };

    // Create charts
    monthlyChart = createChart(document.getElementById('monthlyChart').getContext('2d'), monthlyChartData, 'Justifiable Homicides', 'line');
    yearlyChart = createChart(document.getElementById('yearlyChart').getContext('2d'), yearlyChartData, 'Justifiable Homicides');
    ytdChart = createChart(document.getElementById('ytdChart').getContext('2d'), ytdChartData, 'Justifiable Homicides');
  });
</script>


<h3>Minneapolis: Justifiable Homicide</h3>

<h4 class="source">Data sources: Minneapolis Police Department</h4>

<div class="def"><p>Justifiable homicide is any homicide deemed in self-defense and is not considered a crime. Sometimes officer-involved killings are included in this count if MPD conducted an investigation, but mostly the metric represents civilian self-defense killings.</p></div>

{#if justifiedYTDComparison && justifiedYTDComparison.length > 0}
<p>
  Minneapolis has recorded <strong>{justifiedYTDComparison[justifiedYTDComparison.length - 1].YTDCount}</strong> justifieds this year, a
  <span class={justifiedYTDComparison[justifiedYTDComparison.length - 1].YTDPercentageChange >= 0 ? 'positive' : 'negative'}>
    <strong>
      {typeof justifiedYTDComparison[justifiedYTDComparison.length - 1].YTDPercentageChange === 'number' ? 
        (justifiedYTDComparison[justifiedYTDComparison.length - 1].YTDPercentageChange > 0 ? `+${justifiedYTDComparison[justifiedYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%` : `${justifiedYTDComparison[justifiedYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%`) 
        : 'N/A'}
    </strong>
  </span> change from last year's <strong>{justifiedYTDComparison[justifiedYTDComparison.length - 1].PrevYTDCount}</strong> justifieds at this time.
</p>
<p>
  Compared to 2019's count of <strong>{justifiedYTDComparison[0].YTDCount}</strong> justifieds, the change is
  <span class={
    (justifiedYTDComparison[justifiedYTDComparison.length - 1].YTDCount - justifiedYTDComparison[0].YTDCount) >= 0 ? 'positive' : 'negative'}>
    <strong>
      {typeof justifiedYTDComparison[justifiedYTDComparison.length - 1].YTDCount === 'number' && typeof justifiedYTDComparison[0].YTDCount === 'number' ?
        (((justifiedYTDComparison[justifiedYTDComparison.length - 1].YTDCount - justifiedYTDComparison[0].YTDCount) / justifiedYTDComparison[0].YTDCount * 100) > 0 ?
        `+${((justifiedYTDComparison[justifiedYTDComparison.length - 1].YTDCount - justifiedYTDComparison[0].YTDCount) / justifiedYTDComparison[0].YTDCount * 100).toFixed(0)}%` :
        `${((justifiedYTDComparison[justifiedYTDComparison.length - 1].YTDCount - justifiedYTDComparison[0].YTDCount) / justifiedYTDComparison[0].YTDCount * 100).toFixed(0)}%`)
        : 'N/A'}
    </strong>
  </span>.
</p>
{/if}


<h4>Year-to-date justifiable homicides trend</h4>
<div class="chart-container">
  <canvas id="ytdChart"></canvas>
</div>
<div class="download"><a href="../../store/justified/justified_ytd_comparison.csv">Download Minneapolis justifiable homicides year-to-date data</a></div> 

<p>&nbsp;</p>
<h4>Monthly monthly trend</h4>
<div class="chart-container">
  <canvas id="monthlyChart"></canvas>
</div>
<div class="download"><a href="../../store/justified/justified_monthly_comparison.csv">Download Minneapolis justifiable homicides by month data</a></div>

<p>&nbsp;</p>
<h4>Yearly justifiable homicides trend</h4>
<div class="chart-container">
  <canvas id="yearlyChart"></canvas>
</div>
<div class="download"><a href="../../store/justified/justified_yearly_incident_counts.csv">Download Minneapolis justifiable homicides by year data</a></div>

<p>&nbsp;</p>
<h4>Justifiable homicides by neighborhood</h4>
<p>Click a map to expand.</p>
<div class="map-container">
  {#each ['../../store/justified/justified_map_2022.svg', '../../store/justified/justified_map_2023.svg', '../../store/justified/justified_map_2024.svg', '../../store/justified/justified_map_2025.svg'] as image}
    <img src={image} alt={`justified Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
  {/each}
</div>

{#if $activeImage}
  <div class="lightbox" on:click={closeLightbox}>
    <img src={$activeImage} alt="Expanded Image">
  </div>
{/if}
<div class="download"><a href="../../store/justified/justified_geo.csv">Download Minneapolis justifiable homicides by neighborhood data</a></div>
<div class="download"><a href="../../store/justified/justified_neighborhoods.geojson">Download Minneapolis justifiable homicides by neighborhood GEOJSON</a></div>
<div class="download"><a href="../../store/justified/justified_raw.csv">Download Minneapolis justifiable homicides raw CSV file (includes incident coordinates)</a></div>

<p>&nbsp;</p>
<h4>Links</h4>
<ul>
  <li><a href="https://docs.google.com/spreadsheets/d/1ntBqZokbzsPQEatu-rlHsIYKq2ngM0hoO1xXmRBQ8jc/edit#gid=1736309950">Star Tribune: Minneapolis Homicides Database</a></li>
  <li><a href="https://tableau.minneapolismn.gov/views/CrimeDashboard/Summary?%3Adisplay_count=n&%3Aiid=5&%3Aorigin=viz_share_link&%3AshowAppBanner=false&%3AshowVizHome=n&%3Atabs=yes&%3Atoolbar=no&%3AisGuestRedirectFromVizportal=y&%3Aembed=y">Minneapolis NIBRS Crime Dashboard</a> | <a href="https://opendata.minneapolismn.gov/datasets/cityoflakes::crime-data/about">raw data</a></li>
</ul>

<style>

</style>