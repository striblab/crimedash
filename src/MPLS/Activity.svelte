<script>
  import { onMount } from 'svelte';
  import Chart from 'chart.js/auto';

  import mpdDispatchData from '../../store/activity/mpd_dispatch.json';
  import mplsStopsData from '../../store/activity/stops_average.json';

  let dispatchChart, stopsChart;

  function createChart(ctx, chartData, title, type = 'line') {
    return new Chart(ctx, {
      type: type,
      data: {
        labels: chartData.labels,
        datasets: chartData.datasets,
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: '7-day rolling dispatch average'
            }
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

  onMount(() => {
    // Prepare data for mpd_dispatch.json
    const dispatchLabels = mpdDispatchData.map(item => item.date);
    const oiAverageDataset = {
      label: 'Officer-initiated/other Calls',
      data: mpdDispatchData.map(item => item.oi_average),
      borderColor: 'rgb(54, 162, 235)',
      backgroundColor: 'rgba(54, 162, 235, 0.5)',
      pointRadius: 0,
      borderWidth: 0.9,
      fill: false
    };
    const average911Dataset = {
      label: '911 Calls',
      data: mpdDispatchData.map(item => item["911_average"]),
      borderColor: 'rgb(255, 99, 132)',
      backgroundColor: 'rgba(255, 99, 132, 0.5)',
      pointRadius: 0,
      borderWidth: 0.9,
      fill: false
    };

    dispatchChart = createChart(document.getElementById('dispatchChart').getContext('2d'), {
      labels: dispatchLabels,
      datasets: [oiAverageDataset, average911Dataset]
    }, 'MPD Dispatch Calls');

    // Prepare data for mpls_stops.json
    const stopsLabels = mplsStopsData.map(item => item.date.toString());
    const stopsDataset = {
      label: '7-day rolling stops average',
      data: mplsStopsData.map(item => item.Incidents),
      borderColor: 'rgb(54, 162, 235)',
      backgroundColor: 'rgba(54, 162, 235, 0.5)',
      pointRadius: 0,
      borderWidth: 0.9,
      fill: false
    };

    stopsChart = createChart(document.getElementById('stopsChart').getContext('2d'), {
      labels: stopsLabels,
      datasets: [stopsDataset]
    }, 'MPLS Stops Weekly Average');
  });
</script>

<h3>Minneapolis: Police Activity</h3>

<h4 class="source">Data sources: Minneapolis Police Department</h4>

<div class="def"><p>Police activity includes any call police are dispatched to or initiate themselves, including traffic stops.</p></div>


<p>Post-Floyd, Minneapolis police have fallen back into a largely reactive mode as 911 calls spiked and officer-initiated proactive operations flatlined.</p>

<div class="chart-container">
    <canvas id="dispatchChart"></canvas>
  </div>
<div class="download"><a href="../store/activity/mpd_activity.csv">Download Minneapolis police daily dispatch rolling averages, 2019-2022</a></div>
<div class="download"><a href="../store/activity/mpd_2019.zip">Download Minneapolis police dispatch data, 2019</a></div>
<div class="download"><a href="../store/activity/mpd_2020.zip">Download Minneapolis police dispatch data, 2020</a></div>
<div class="download"><a href="../store/activity/mpd_2021.zip">Download Minneapolis police dispatch data, 2021</a></div>
<div class="download"><a href="../store/activity/mpd_2022_a.zip">Download Minneapolis police dispatch data, Q1 2022</a></div>
<div class="download"><a href="../store/activity/mpd_2022_b.zip">Download Minneapolis police dispatch data, Q2 2022</a></div>
<div class="download"><a href="../store/activity/mpd_2022_c.zip">Download Minneapolis police dispatch data, Q3 2022</a></div>
<div class="download"><a href="../store/activity/mpd_2022_d.zip">Download Minneapolis police dispatch data, Q4 2022</a></div>
<div class="download"><a href="../store/activity/mpd_2023_a.zip">Download Minneapolis police dispatch data, Jan-Jun 2023</a></div>
<div class="download"><a href="../store/activity/mpd_2023_b.zip">Download Minneapolis police dispatch data, July-Dec 2023</a></div>
<div class="download"><a href="../store/activity/mpd_2024_a.zip">Download Minneapolis police dispatch data, Jan-Jun 2024</a></div>
<p>&nbsp;</p>

<p>Minneapolis police have also gradually reduced their number of traffic stops in recent years.</p>

<div class="chart-container">
    <canvas id="stopsChart"></canvas>
  </div>
  
<div class="download"><a href="../store/activity/Police_Stop_Data.csv">Download Minneapolis police stops data, 2017-present</a></div>
<div class="download"><a href="../store/activity/stops_average.csv">Download Minneapolis police stops daily rolling averages, 2017-present</a></div>

<h4>Links</h4>
<ul>
    <li><a href="https://www.minneapolismn.gov/government/government-data/datasource/911-current-incidents-dashboard/">911 and Emergency Communications Center Incidents Dashboard</a> | <a href="https://opendata.minneapolismn.gov/datasets/c0ee6f12407044a09d8d48b2c7da3ada_0/">DATA</a></li>
    <li><a href="https://tableau.minneapolismn.gov/views/MPDStopDataOpenDataInsideMPD/MPDStopInformation?:embed=y&:display_count=no&:showAppBanner=false&:showVizHome=no&:origin=viz_share_link">Minneapolis Police Stops</a> | <a href="https://opendata.minneapolismn.gov/datasets/police-stop-data">DATA</a></li>
    <li><a href="https://minneapolis.service-now.com/opencityportal">Minneapolis Open City</a></li>
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
</style>
