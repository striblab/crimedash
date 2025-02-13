<script>
    import { onMount } from 'svelte';
    import Chart from 'chart.js/auto';
    import mnHomicideRate from '../store/mn/mn_homicides.json';
    import mnProperty from '../store/mn/mn_property.json';
    import mnViolentCrime from '../store/mn/mn_violence.json';
  
    let mnhomicideChart, mnpropertyChart, mnviolentCrimeChart;

    function createChart(ctx, chartData, title, type = 'line') {
    return new Chart(ctx, {
        type: type,
        data: {
            labels: chartData.map(item => item.year.toString()),
            datasets: [
                {
                    label: title + ' - MN',
                    data: chartData.map(item => item.MN),
                    backgroundColor: 'rgba(255, 99, 132, 0.2)', 
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 1
                },
                {
                    label: title + ' - US',
                    data: chartData.map(item => item.US),
                    backgroundColor: 'rgba(54, 162, 235, 0.2)', 
                    borderColor: 'rgba(54, 162, 235, 1)', 
                    borderWidth: 1
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Value' // Updated title text
                    }
                }
            }
        }
    });
}


    onMount(() => {
        const ctxHomicide = document.getElementById('mnhomicideChart').getContext('2d');
       mnhomicideChart = createChart(ctxHomicide, mnHomicideRate, 'Homicide Rate');

        const ctxProperty = document.getElementById('mnpropertyChart').getContext('2d');
        mnpropertyChart = createChart(ctxProperty, mnProperty, 'Property Crimes');

        const ctxViolent = document.getElementById('mnviolentCrimeChart').getContext('2d');
        mnviolentCrimeChart = createChart(ctxViolent, mnViolentCrime, 'Violent Crimes');
    });
  </script>

<h3>Statewide crime trends</h3>

<h4 class="source">Data sources: FBI</h4>

<p>Minnesota's homicide rate per 100,000 residents, despite a surge in the 1990s, has long remained below national averages while still following national trends.</p>
<div class="chart-container">
    <canvas id="mnhomicideChart"></canvas>
  </div>
  <div class="download"><a href="../store/mn/mn_homicides.csv">Download Minnesota homicide rate data</a></div>
  <div class="download"><a href="../store/mn/MNSHR65_22.csv.zip">Download Minnesota FBI Supplementary Homicide Report, 1976-2022</a></div>

<p>&nbsp;</p>

<p>Similarly, Minnesota's overall violent crime rate per 100,000 residents remains below the national average while still broadly following national trends. Violent crimes include murder, aggravated assault, rape and robbery.</p>
<div class="chart-container">
    <canvas id="mnviolentCrimeChart"></canvas>
  </div>
  <div class="download"><a href="../store/mn/mn_violence.csv">Download Minnesota violence rate data</a></div>

<p>&nbsp;</p>

<p>Minnesota's rate of property crimes per 100,000 residents has longed matched national trends and levels. Property crimes include vehicular theft, burglary, larceny and arson.</p>
<div class="chart-container">
    <canvas id="mnpropertyChart"></canvas>
  </div>
<div class="download"><a href="../store/mn/mn_property.csv">Download Minnesota property crime rate data</a></div>

<h4>Links</h4>
<ul>
    <li><a href="https://www.lrl.mn.gov/edocs/edocs?oclcnumber=20080426">All Minnesota UCRs ever</a></li>
    <li><a href="https://cde.state.mn.us/">Minnesota Crime Data Explorer</a></li>
    <li><a href="https://cde.state.mn.us/DownloadData/OffenseCountyMunicipalByAgencyDownload/">Minnesota NIBRS data by year</a></li>
    <li><a href="https://bcadataportal.state.mn.us/DWI">Minnesota DWI dashboard</a></li>
    <li><a href="https://cde.state.mn.us/Carjacking/Carjacking">Minnesota carjacking dashboard</a></li>
    <li><a href="https://cde.state.mn.us/LawEnforcementEmployeeInformation/LawEnforcementEmployeeInformation">Minnesota LEO employment dashboard</a></li>
    <li><a href="https://cde.state.mn.us/DrugArrests/DrugArrests">Minnesota drug arrests dashboard</a></li>
    <li><a href="https://www.health.state.mn.us/communities/injury/midas/mnvdrs.html">Minnesota Violent Death Reporting System</a></li>
</ul>

<style>

</style>
  