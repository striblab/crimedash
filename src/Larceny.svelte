<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
    import Chart from 'chart.js/auto';
  
  import larcenyMonthlyComparison from './data/larceny_monthly_comparison.json';
  import larcenyYearlyIncidentCounts from './data/larceny_yearly_incident_counts.json';
  import larcenyYTDComparison from './data/larceny_ytd_comparison.json';
  import larcenyPrecincts from './data/larceny_precinct.json';

  let monthlyChart, yearlyChart, ytdChart, precinctChart;
  let resizeTimer;

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
            beginAtZero: true,
            stacked: stacked
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

  function aggregateAndProcessData() {
    // Assuming all data is sorted by year or date
    const ytdTotal = larcenyYTDComparison.reduce((acc, cur) => acc + cur.YTDCount, 0);
    const lastYearTotal = larcenyYTDComparison.length > 1 ? larcenyYTDComparison[larcenyYTDComparison.length - 2].YTDCount : 0;
    const percentageChangeYTD = lastYearTotal ? ((ytdTotal - lastYearTotal) / lastYearTotal * 100) : 0;

    aggregateData.set({
      currentYearLarcenies: ytdTotal,
      lastYearLarcenies: lastYearTotal,
      percentageChangeYTD
    });
  }

  function processData(data, labelField, countField) {
    const labels = [...new Set(data.map(item => item[labelField]))].sort();
    const totalData = labels.map(label => {
      const items = data.filter(item => item[labelField] === label);
      return items.reduce((acc, cur) => acc + cur[countField], 0);
    });

    return { labels, datasets: [{ label: 'Total Larcenies', data: totalData, backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0.8)', fill: false }] };
  }

  function preparePrecinctChartData() {
    const years = [...new Set(larcenyPrecincts.map(item => item.Year))].sort();
    const precincts = [...new Set(larcenyPrecincts.map(item => item.Precinct))];
    const datasets = precincts.map(precinct => {
      const precinctColor = `hsl(${Math.random() * 360}, 70%, 50%)`;
      const data = years.map(year => {
        const items = larcenyPrecincts.filter(item => item.Year === year && item.Precinct === precinct);
        return items.reduce((acc, cur) => acc + cur.OffenseCount, 0);
      });
      return {
        label: `Precinct ${precinct}`,
        data: data,
        borderColor: precinctColor,
        backgroundColor: 'rgba(0, 0, 0, 0)', // Transparent for line charts
        fill: false
      };
    });

    return { labels: years, datasets };
  }

  function handleResize() {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(() => {
      lmonthlyChart.resize();
      lunfireMonthlyComparisonyearlyChart.resize();
      lytdChart.resize();
      lprecinctChart.resize();
    }, 250);
  }

  onMount(() => {
    window.addEventListener('resize', handleResize);

    const monthlyChartData = processData(larcenyMonthlyComparison, 'Date', 'IncidentCount');
    monthlyChart = createChart(document.getElementById('lmonthlyChart').getContext('2d'), monthlyChartData, 'Monthly Larcenies', 'line');

    const yearlyChartData = processData(larcenyYearlyIncidentCounts, 'Year', 'OffenseCount');
    yearlyChart = createChart(document.getElementById('lyearlyChart').getContext('2d'), yearlyChartData, 'Yearly Larcenies', 'bar', true);

    const ytdChartData = processData(larcenyYTDComparison, 'Year', 'YTDCount');
    ytdChart = createChart(document.getElementById('lytdChart').getContext('2d'), ytdChartData, 'YTD Larcenies', 'bar', true);

    const precinctChartData = preparePrecinctChartData();
    precinctChart = createChart(document.getElementById('lprecinctChart').getContext('2d'), precinctChartData, 'Precinct Larcenies', 'line');
  });
  </script>


  <h3>Minneapolis: Larceny</h3>
  
  <p>Larcenies are an aggregate of the following offenses: <em>All Other Larceny, Theft From Motor Vehicle, Pocket-picking, Purse-snatching, Shoplifting, Theft From Building, Theft From Coin-Operated Machine or Device, Theft of Motor Vehicle Parts or Accessories</em>. Download the CSV files for those individual breakdowns.</p>

  
  <h4>Year-to-date larceny trend</h4>
  <div class="chart-container">
    <canvas id="lytdChart"></canvas>
  </div>
  <div class="download"><a href="../store/larceny/larceny_ytd_comparison.csv">Download Minneapolis larcenies year-to-date data</a></div> 
  
  <p>&nbsp;</p>
  <h4>Monthly larceny trend</h4>
  <div class="chart-container">
    <canvas id="lmonthlyChart"></canvas>
  </div>
  <div class="download"><a href="../store/larceny/larceny_monthly_comparison.csv">Download Minneapolis larcenies by month data</a></div>
  
  <p>&nbsp;</p>
  <h4>Yearly larceny trend</h4>
  <div class="chart-container">
    <canvas id="lyearlyChart"></canvas>
  </div>
  <div class="download"><a href="../store/larceny/larceny_yearly_incident_counts.csv">Download Minneapolis larcenies by year data</a></div>
  <div class="download"><a href="../store/larceny/larceny_historical.csv">Download historical Minneapolis SRS larcenies data 1985-2022 (includes clearances)</a></div>
  
  
  <p>&nbsp;</p>
  <h4>Larcenies by police precinct</h4>
  <div class="chart-container">
    <canvas id="lprecinctChart"></canvas>
  </div>
  <div class="download"><a href="../store/larceny/larceny_precinct.csv">Download Minneapolis larcenies by police precinct data</a></div>
  
  <p>&nbsp;</p>
  <h4>Larcenies by neighborhood</h4>
  <p>Click a map to expand.</p>
  <div class="map-container">
    {#each ['../store/larceny/larceny_map_2019.svg', '../store/larceny/larceny_map_2020.svg', '../store/larceny/larceny_map_2021.svg', '../store/larceny/larceny_map_2022.svg', '../store/larceny/larceny_map_2023.svg', '../store/larceny/larceny_map_2024.svg'] as image}
      <img src={image} alt={`larceny Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
    {/each}
  </div>
  
  {#if $activeImage}
    <div class="lightbox" on:click={closeLightbox}>
      <img src={$activeImage} alt="Expanded Image">
    </div>
  {/if}
  <div class="download"><a href="../store/larceny/larceny_geo.csv">Download Minneapolis larcenies by neighborhood data</a></div>
  <div class="download"><a href="../store/larceny/larceny_neighborhoods.geojson">Download Minneapolis larcenies by neighborhood GEOJSON</a></div>
  <div class="download"><a href="../store/larceny/larceny_raw.csv">Download Minneapolis larcenies raw CSV file (includes incident coordinates)</a></div>
  
  
  
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
  </style>