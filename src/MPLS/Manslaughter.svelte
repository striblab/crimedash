<script>
  import { onMount } from 'svelte';
  import { writable } from 'svelte/store';

  import Chart from 'chart.js/auto';

  import manslaughterMonthlyComparison from '../data/manslaughter_monthly_comparison.json';
  import manslaughterYearlyIncidentCounts from '../data/manslaughter_yearly_incident_counts.json';
  import manslaughterYTDComparison from '../data/manslaughter_ytd_comparison.json';

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
    const monthlyChartData = { labels: manslaughterMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly Manslaughters', data: manslaughterMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0.8)', borderWidth: 1 }] };
    const yearlyChartData = { labels: manslaughterYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly Manslaughters', data: manslaughterYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0.8)', borderWidth: 0 }] };
    const ytdChartData = { labels: manslaughterYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD Manslaughters', data: manslaughterYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0.8)', borderWidth: 0}] };

    // Create charts
    monthlyChart = createChart(document.getElementById('monthlyChart').getContext('2d'), monthlyChartData, 'manslaughters', 'line');
    yearlyChart = createChart(document.getElementById('yearlyChart').getContext('2d'), yearlyChartData, 'manslaughters');
    ytdChart = createChart(document.getElementById('ytdChart').getContext('2d'), ytdChartData, 'manslaughters');
  });
</script>


<h3>Minneapolis: Manslaughter</h3>

<h4 class="source">Data sources: Minneapolis Police Department</h4>

<div class="def"><p>Negligent Manslaughter is any homicide deemed unintentional, even if it was reckless, including most vehicular homicides. Manslaughters are not usually included in Star Tribune homicide counts.</p></div>

{#if manslaughterYTDComparison && manslaughterYTDComparison.length > 0}
<p>
  Minneapolis has recorded <strong>{manslaughterYTDComparison[manslaughterYTDComparison.length - 1].YTDCount}</strong> manslaughters this year, a
  <span class={manslaughterYTDComparison[manslaughterYTDComparison.length - 1].YTDPercentageChange >= 0 ? 'positive' : 'negative'}>
    <strong>
      {typeof manslaughterYTDComparison[manslaughterYTDComparison.length - 1].YTDPercentageChange === 'number' ? 
        (manslaughterYTDComparison[manslaughterYTDComparison.length - 1].YTDPercentageChange > 0 ? `+${manslaughterYTDComparison[manslaughterYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%` : `${manslaughterYTDComparison[manslaughterYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%`) 
        : 'N/A'}
    </strong>
  </span> change from last year's <strong>{manslaughterYTDComparison[manslaughterYTDComparison.length - 1].PrevYTDCount}</strong> manslaughters at this time.
</p>
<p>
  Compared to 2019's count of <strong>{manslaughterYTDComparison[0].YTDCount}</strong> manslaughters, the change is
  <span class={
    (manslaughterYTDComparison[manslaughterYTDComparison.length - 1].YTDCount - manslaughterYTDComparison[0].YTDCount) >= 0 ? 'positive' : 'negative'}>
    <strong>
      {typeof manslaughterYTDComparison[manslaughterYTDComparison.length - 1].YTDCount === 'number' && typeof manslaughterYTDComparison[0].YTDCount === 'number' ?
        (((manslaughterYTDComparison[manslaughterYTDComparison.length - 1].YTDCount - manslaughterYTDComparison[0].YTDCount) / manslaughterYTDComparison[0].YTDCount * 100) > 0 ?
        `+${((manslaughterYTDComparison[manslaughterYTDComparison.length - 1].YTDCount - manslaughterYTDComparison[0].YTDCount) / manslaughterYTDComparison[0].YTDCount * 100).toFixed(0)}%` :
        `${((manslaughterYTDComparison[manslaughterYTDComparison.length - 1].YTDCount - manslaughterYTDComparison[0].YTDCount) / manslaughterYTDComparison[0].YTDCount * 100).toFixed(0)}%`)
        : 'N/A'}
    </strong>
  </span>.
</p>
{/if}


<h4>Year-to-date manslaughter trend</h4>
<div class="chart-container">
  <canvas id="ytdChart"></canvas>
</div>
<div class="download"><a href="../../store/manslaughter/manslaughter_ytd_comparison.csv">Download Minneapolis manslaughters year-to-date data</a></div> 

<p>&nbsp;</p>
<h4>Monthly monthly trend</h4>
<div class="chart-container">
  <canvas id="monthlyChart"></canvas>
</div>
<div class="download"><a href="../../store/manslaughter/manslaughter_monthly_comparison.csv">Download Minneapolis manslaughters by month data</a></div>

<p>&nbsp;</p>
<h4>Yearly manslaughter trend</h4>
<div class="chart-container">
  <canvas id="yearlyChart"></canvas>
</div>
<div class="download"><a href="../../store/manslaughter/manslaughter_yearly_incident_counts.csv">Download Minneapolis manslaughters by year data</a></div>

<p>&nbsp;</p>
<h4>Manslaughters by neighborhood</h4>
<p>Click a map to expand.</p>
<div class="map-container">
  {#each ['../../store/manslaughter/manslaughter_map_2019.svg', '../../store/manslaughter/manslaughter_map_2020.svg', '../../store/manslaughter/manslaughter_map_2021.svg', '../../store/manslaughter/manslaughter_map_2022.svg', '../../store/manslaughter/manslaughter_map_2023.svg', '../../store/manslaughter/manslaughter_map_2024.svg', '../../store/manslaughter/manslaughter_map_2025.svg'] as image}
    <img src={image} alt={`manslaughter Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
  {/each}
</div>

{#if $activeImage}
  <div class="lightbox" on:click={closeLightbox}>
    <img src={$activeImage} alt="Expanded Image">
  </div>
{/if}
<div class="download"><a href="../../store/manslaughter/manslaughter_geo.csv">Download Minneapolis manslaughters by neighborhood data</a></div>
<div class="download"><a href="../../store/manslaughter/manslaughter_neighborhoods.geojson">Download Minneapolis manslaughters by neighborhood GEOJSON</a></div>
<div class="download"><a href="../../store/manslaughter/manslaughter_raw.csv">Download Minneapolis manslaughters raw CSV file (includes incident coordinates)</a></div>

<p>&nbsp;</p>
<h4>Links</h4>
<ul>
  <li><a href="https://docs.google.com/spreadsheets/d/1ntBqZokbzsPQEatu-rlHsIYKq2ngM0hoO1xXmRBQ8jc/edit#gid=1736309950">Star Tribune: Minneapolis Homicides Database</a></li>
  <li><a href="https://tableau.minneapolismn.gov/views/CrimeDashboard/Summary?%3Adisplay_count=n&%3Aiid=5&%3Aorigin=viz_share_link&%3AshowAppBanner=false&%3AshowVizHome=n&%3Atabs=yes&%3Atoolbar=no&%3AisGuestRedirectFromVizportal=y&%3Aembed=y">Minneapolis NIBRS Crime Dashboard</a> | <a href="https://opendata.minneapolismn.gov/datasets/cityoflakes::crime-data/about">raw data</a></li>
</ul>

<style>

</style>