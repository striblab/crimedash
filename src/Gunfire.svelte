<script>
  import { onMount } from 'svelte';
  import { writable } from 'svelte/store';
  import Chart from 'chart.js/auto';

  import gunfireMonthlyComparison from './data/gunfire_monthly_comparison.json';
  import gunfireYearlyIncidentCounts from './data/gunfire_yearly_incident_counts.json';
  import gunfireYTDComparison from './data/gunfire_ytd_comparison.json';
  import gunfirePrecincts from './data/gunfire_precinct.json';

  let gmonthlyChart, gyearlyChart, gytdChart, gprecinctChart;
  let resizeTimer;
  let lastYear, thisYear, change, firstYear, pchange;

  let activeImage = writable(null);

    function openLightbox(image) {
      activeImage.set(image);
    }

    function closeLightbox() {
      activeImage.set(null);
    }

    function createChart(ctx, chartData, title, type = 'bar', stacked = false) {
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
              stacked: stacked,
              beginAtZero: true
            },
            x: {
              stacked: stacked
            }
          },
          plugins: {
            legend: {
              display: true,
              position: 'top'
            }
          }
        }
      });
    }

    function processData(data, labelField, countField) {
      const labels = [...new Set(data.map(item => item[labelField]))].sort();
      const datasets = [{
        label: 'Total Gunfire Reports',
        data: labels.map(label => {
          const items = data.filter(item => item[labelField] === label);
          return items.reduce((acc, cur) => acc + cur[countField], 0);
        }),
        backgroundColor: 'rgba(70, 130, 180, 0.8',
        borderColor: 'rgba(70, 130, 180, 0.8',
        fill: false
      }];

      return { labels, datasets };
    }

    function preparePrecinctChartData() {
      const years = [...new Set(gunfirePrecincts.map(item => item.Year))].sort();
      const precincts = [...new Set(gunfirePrecincts.map(item => item.Precinct))];
      const datasets = precincts.map(precinct => {
        const data = years.map(year => {
          const items = gunfirePrecincts.filter(item => item.Year === year && item.Precinct === precinct);
          return items.reduce((acc, cur) => acc + cur.OffenseCount, 0);
        });
        return {
          label: `Precinct ${precinct}`,
          data: data,
          borderColor: `hsl(${Math.random() * 360}, 70%, 50%)`,
          backgroundColor: 'rgba(0, 0, 0, 0)', // Transparent for line charts
          fill: false
        };
      });

      return { labels: years, datasets };
    }

    function handleResize() {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(() => {
          gmonthlyChart.resize();
          gmonthlyChart.resize();
          gytdChart.resize();
          gprecinctChart.resize();
        }, 250);
      }

      onMount(() => {
          window.addEventListener('resize', handleResize);

          const monthlyChartData = processData(gunfireMonthlyComparison, 'Date', 'IncidentCount');
          gmonthlyChart = createChart(document.getElementById('gmonthlyChart').getContext('2d'), monthlyChartData, 'Monthly shots fired', 'line');

          const yearlyChartData = processData(gunfireYearlyIncidentCounts, 'Year', 'OffenseCount');
          gyearlyChart = createChart(document.getElementById('gyearlyChart').getContext('2d'), yearlyChartData, 'Yearly shots fired', 'bar');

          const ytdChartData = processData(gunfireYTDComparison, 'Year', 'YTDCount');
          gytdChart = createChart(document.getElementById('gytdChart').getContext('2d'), ytdChartData, 'YTD shots fired', 'bar');

          thisYear = ytdChartData.datasets[0].data[ytdChartData.datasets[0].data.length-1];
          lastYear = ytdChartData.datasets[0].data[ytdChartData.datasets[0].data.length-2];
          change = ((thisYear - lastYear) / lastYear) * 100;
          firstYear = ytdChartData.datasets[0].data[0];
          pchange = ((thisYear - firstYear) / firstYear) * 100;

          const precinctChartData = preparePrecinctChartData();
          gprecinctChart = createChart(document.getElementById('gprecinctChart').getContext('2d'), precinctChartData, 'Precinct shots fired', 'line');
    });     
</script>


<h3>Minneapolis: Gunfire</h3>

<div class="disclaimer"><p>Minneapolis gunfire reports include 911 calls, ShotsSpotter activations, shooting scenes and hospital admissions with gunshot wounds.</p></div>

{#if thisYear > 0}
<p>
  Minneapolis has recorded <strong>{thisYear}</strong> reported gunshots this year, a
  <span class={change >= 0 ? 'positive' : 'negative'}>
    <strong>
      {typeof change === 'number' ? 
        (change > 0 ? `+${change.toFixed(0)}%` : `${change.toFixed(0)}%`) 
        : 'N/A'}
    </strong>
  </span> change from last year's <strong>{lastYear}</strong> reported gunshots at this time.
</p>
<p>
  Compared to 2019's count of <strong>{firstYear}</strong>, the change is <span class={pchange >= 0 ? 'positive' : 'negative'}>
    <strong>
      {typeof pchange === 'number' ? 
        (pchange > 0 ? `+${pchange.toFixed(0)}%` : `${pchange.toFixed(0)}%`) 
        : 'N/A'}
    </strong>
  </span>.
</p>
{/if}

<h4>Year-to-date gunfire trend</h4>
<div class="chart-container">
  <canvas id="gytdChart"></canvas>
</div>
<div class="download"><a href="../store/gunfire/gunfire_ytd_comparison.csv">Download Minneapolis shots fired year-to-date data</a></div> 

<p>&nbsp;</p>
<h4>Monthly gunfire trend</h4>
<div class="chart-container">
  <canvas id="gmonthlyChart"></canvas>
</div>
<div class="download"><a href="../store/gunfire/gunfire_monthly_comparison.csv">Download Minneapolis shots fired by month data</a></div>

<p>&nbsp;</p>
<h4>Yearly gunfire trend</h4>
<div class="chart-container">
  <canvas id="gyearlyChart"></canvas>
</div>
<div class="download"><a href="../store/gunfire/gunfire_yearly_incident_counts.csv">Download Minneapolis shots fired by year data</a></div>
<div class="download"><a href="../store/gunfire/mpls_shots_fired.csv">Download historical Minneapolis shots fired data, 2008-present</a></div>


<p>&nbsp;</p>
<h4>Shots fired by police precinct</h4>
<div class="chart-container">
  <canvas id="gprecinctChart"></canvas>
</div>
<div class="download"><a href="../store/gunfire/gunfire_precinct.csv">Download Minneapolis shots fired by police precinct data</a></div>

<p>&nbsp;</p>
<h4>Shots fired by neighborhood</h4>
<p>Click a map to expand.</p>
<div class="map-container">
  {#each ['../store/gunfire/gunfire_map_2019.svg', '../store/gunfire/gunfire_map_2020.svg', '../store/gunfire/gunfire_map_2021.svg', '../store/gunfire/gunfire_map_2022.svg', '../store/gunfire/gunfire_map_2023.svg', '../store/gunfire/gunfire_map_2024.svg'] as image}
    <img src={image} alt={`gunfire Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
  {/each}
</div>

{#if $activeImage}
  <div class="lightbox" on:click={closeLightbox}>
    <img src={$activeImage} alt="Expanded Image">
  </div>
{/if}
<div class="download"><a href="../store/gunfire/gunfire_geo.csv">Download Minneapolis shots fired by neighborhood data</a></div>
<div class="download"><a href="../store/gunfire/gunfire_neighborhoods.geojson">Download Minneapolis shots fired by neighborhood GEOJSON</a></div>
<div class="download"><a href="../store/gunfire/gunfire_raw.csv">Download Minneapolis shots fired raw CSV file (includes incident coordinates)</a></div>


<p>&nbsp;</p>
<h4>Links</h4>
<ul>
  <li><a href="https://cityoflakes.maps.arcgis.com/apps/webappviewer/index.html?id=292a52a52b354387a94020db10c19749">Minneapolis Gunfire Activity Map</a> | <a href="https://opendata.minneapolismn.gov/datasets/shots-fired/explore?location=44.969425%2C-93.264019%2C12.00">DATA</a></li>
  <li><a href="https://tableau.minneapolismn.gov/views/MStatGunshotData/GunshotWoundDashboard-byDate?:showAppBanner=false&:display_count=n&:showVizHome=n&:origin=viz_share_link&:iid=6&:isGuestRedirectFromVizportal=y&:embed=y">Minneapolis Gunshot Wounds/Shootings</a></li>
  <li><a href="https://www.gunviolencearchive.org/query/4c112967-14d3-41b1-871f-2c0dfa095f9b">Gun Violence Archives</a></li>
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
  .positive {
  color: red;
  }
  .negative {
    color: green;
  }
  .map-container {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-around;
    gap: 20px;
  }

  img {
    width: 200px;
    height: auto;
    cursor: pointer;
    transition: transform 0.2s;
    border:1px solid #dddddd;
  }

  img:hover {
    transform: scale(1.05);
  }

  .lightbox {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background-color: white;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
  }

  .lightbox img {
    max-width: 90%; 
    max-height: 90%;
    height: auto;
    width: auto;
  }
  .disclaimer {
    color:#de2d26;
  }
</style>