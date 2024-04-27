<script>
  import { onMount } from 'svelte';
  import Chart from 'chart.js/auto';
  import assaultLEOKA from '../store/leoka/mn_leoka_assaults.json';
  import killedLEOKA from '../store/leoka/mn_leoka_killed.json';
  import incidentsLEOKA from '../store/leoka/mn_leoka_incidents.json';

  let assaultChart, killedChart, incidentsChart;

  let totalAccidental = killedLEOKA.reduce((sum, record) => sum + (record.Accidental || 0), 0);
  let totalFelonious = killedLEOKA.reduce((sum, record) => sum + (record.Felonious || 0), 0);

  function createChart(ctx, chartData, title, dataField, type = 'line') {
    return new Chart(ctx, {
        type: type,
        data: {
            labels: chartData.map(item => item.year.toString()),
            datasets: [{
                label: title,
                data: chartData.map(item => item[dataField]),
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
                        text: dataField
                    }
                }
            }
        }
    });
}

function createKilledChart(ctx, chartData, title, type = 'bar') {
    return new Chart(ctx, {
        type: type,
        data: {
            labels: chartData.map(item => item.year.toString()),
            datasets: [
                {
                    label: title + ' - Accidental',
                    data: chartData.map(item => item.Accidental),

                    backgroundColor: 'rgba(54, 162, 235, 0.8)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1,
                    stack: 'stack0'
                },
                {
                    label: title + ' - Felonious',
                    data: chartData.map(item => item.Felonious),
                    backgroundColor: 'rgba(255, 99, 132, 0.8)',
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 1,
                    stack: 'stack0'
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    stacked: true,
                    title: {
                        display: true,
                        text: 'Number of Deaths'
                    }
                },
                x: {
                    stacked: true
                }
            }
        }
    });
}

onMount(() => {
    const ctxAssault = document.getElementById('assaultChart').getContext('2d');
    assaultChart = createChart(ctxAssault, assaultLEOKA, 'Assault Incidents', 'incidents', 'line');

    const ctxKilled = document.getElementById('killedChart').getContext('2d');
    killedChart = createKilledChart(ctxKilled, killedLEOKA, 'Officers Killed');

    const ctxIncidents = document.getElementById('incidentsChart').getContext('2d');
    incidentsChart = createChart(ctxIncidents, incidentsLEOKA, 'Total Offenses', 'incidents', 'bar');

});


</script>

<h3>Law Enforcement Officers Killed or Assaulted</h3>

<h4 class="source">Data sources: Minnesota Bureau of Criminal Apprehension, FBI</h4>

<p>Assaults against police in Minnesota are up about <strong>160%</strong> since 2010, the spike starting in 2020.</p>

<div class="chart-container">
  <canvas id="assaultChart"></canvas>
</div>
<div class="download"><a href="../store/leoka/mn_leo_assaults.csv">Download Minnesota LEO assault incidents 1970-2023</a></div>

<p>&nbsp;</p>

<p>Since 2021, BCA reports more 3,500 assaults against police officers. About 70% were simple assaults like punches, kicks, slaps, bites, etc. About a quarter were aggravated assaults with a deadly weapon like firearms, knives or automobiles. The rest were recorded as intimidation.</p>

<p>Of those more than 3,500 assaults, police were responding to disturbance calls about 30% of the time.</p>

<div class="chart-container">
  <canvas id="incidentsChart"></canvas>
</div>
<div class="download"><a href="../store/leoka/mn_leoka.xlsx">Download Minnesota LEOKA statistics 2021-2023</a></div>

<p>&nbsp;</p>

<p>About <strong class="fel">{totalFelonious}</strong> Minnesota police officers have been killed feloniously and <strong class="acc">{totalAccidental}</strong> accidentally since 1970.</p>

<div class="chart-container">
  <canvas id="killedChart"></canvas>
</div>
<div class="download"><a href="../store/leoka/mn_leo_killed.csv">Download Minnesota LEO killed data 1970-2024</a></div>

<p>&nbsp;</p>

<h4>Links</h4>
<ul>
    <li><a href="https://cde.state.mn.us/LawEnforcementOfficersKilledandAssaulted/LawEnforcementOfficersKilledandAssaulted">Minnesota LEOKA Dashboard</a></li>
    <li><a href="https://cde.ucr.cjis.gov/LATEST/webapp/#/pages/le/leoka">FBI national LEOKA data</a></li>
    <li><a href="https://cde.ucr.cjis.gov/LATEST/webapp/#/pages/le/lesdc">FBI LEO suicide data collection</a></li>
    <li><a href="https://www.odmp.org/search/year?year=2023">Officer Down Memorial Page</a></li>
</ul>



<style>
  .acc {
    color:#59aded;
  }
  .fel {
    color:#ff7994;
  }
</style>
