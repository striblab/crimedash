<script>
  import { onMount } from 'svelte';
  import Chart from 'chart.js/auto';
  import assaultLEOKA from '../../store/leoka/mn_leoka_assaults.json';
  import killedLEOKA from '../../store/leoka/arrests.png';
  import incidentsLEOKA from '../../store/leoka/mn_leoka_incidents.json';

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

<p>Assault incidents against police in Minnesota are up about <strong>160%</strong> since 2010, the spike starting in 2020.</p>

<div class="chart-container">
  <canvas id="assaultChart"></canvas>
</div>
<div class="download"><a href="../store/leoka/mn_leo_assaults.csv">Download Minnesota LEO assault incidents 1970-2023</a></div>

<p>&nbsp;</p>

<p>This increase is a statewide aggregate, so trendlines may look different for specific departments. Midyear trends are difficult to isolate since assaults on police follow crime trends, which swell during summer months.</p>

<p>Since 2021, the BCA reports about 4,000 assault offenses against police officers. About 70% were simple assaults like punches, kicks, slaps, shoving, spitting, biting, etc or attempts at any of those. About a quarter were aggravated assaults where suspect used deadly weapon like firearms, knives and automobiles to threaten or inflict harm upon officers. The remaining offenses were recorded as intimidation.</p>

<p>Of those roughly 4,000 assault offenses, police were responding to disturbance calls about a third of the time.</p>

<div class="chart-container">
  <canvas id="incidentsChart"></canvas>
</div>

<p>&nbsp;</p>

<p>About <strong class="fel">{totalFelonious}</strong> Minnesota police officers have been slain in the line of duty and <strong class="acc">{totalAccidental}</strong> have died in accidents while performing their duties since 1970.</p>

<div class="chart-container">
  <canvas id="killedChart"></canvas>
</div>
<div class="download"><a href="../store/leoka/mn_leo_killed.csv">Download Minnesota LEO killed data 1970-2024</a></div>

<h4>Some notes about LEOKA data:</h4>

<ul id="tips" style="list-style-type: square;">
    <li>LEOKA data appears in annual Minnesota Uniform Crime Reports dating back decades, the earliest clear example appearing in 1970-1971.</li>
    <li>LEOKA statistics are almost always broken down by assault incidents against police, and individual assault offenses within those incidents – be cautious describing the metric you're using (e.g. 2023 recorded 980 assault incidents against officers, and 1,233 separate offenses against officers).</li>
    <li>Because LEOKA already differentiated between incidents and offenses, it seems statistically unaffected by statewide shifts to NIBRS. The only protocol change to LEOKA <a href="https://ucr.fbi.gov/nibrs/nibrsadd_leoka.pdf">required additional details on the submission form</a>.</li>
    <li>NIBRS does allow LEOKA statistics to be retroactively updated, so don't be surprised if <a href="https://cde.state.mn.us/LawEnforcementOfficersKilledandAssaulted/LawEnforcementOfficersKilledandAssaulted">dashboards</a> show varying numbers over time.</li>
    <li>Some feel that using LEOKA numbers in a vacuum is faulty – but isolating relevant comparable baseline metrics is challenging. The reasons behind increased attacks on police seem to be myriad, and rising crime rates and police calls are likely among the drivers.</li>
    <li>But since most LEOKA incidents occur while officers are attempting to arrest or pursue suspects, arrests seem to provide the best (however imperfect) baseline for comparison. Arrests have been declining for years, even amid this jump in assaults on police.</li>
    <img src="../store/leoka/arrests.png" /> 
    <li>Aggravated assaults have also started falling from their 2021 peak as assaults on police rise.</li>
    <img src="../store/leoka/assaults.png" />
    <li>Even just isolating assaults on police with firearms, the trendline rises rapidly from 2020 onward. <em><a href="https://minnesotareformer.com/2024/02/19/more-criminal-suspects-are-shooting-at-minnesota-police-officers-data-show/">The Minnesota Reformer</a></em> has a solid piece on this.</li>
    <img src="../store/leoka/fireams.png" />
    <li>Critics also argue LEOKA numbers are relatively small, particularly slayings of officers. But this is the same argument used against quantifying police use-of-force, particularly deadly force. The number of police-involved killings, justified and unjustified, could be easily washed out in rates of overall law enforcement activity. But we don't assign statistical relevance to human lives and record every murder regardless of circumstance.</li>
</ul>

<div class="download"><a href="../store/leoka/mn_leoka.xlsx">Download Minnesota LEOKA statistics over time</a></div>

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
  span {
    text-decoration-line: underline;
}
#tips li {
    line-height:180%;
    margin-top:10px;
    margin-bottom:10px
}
</style>
