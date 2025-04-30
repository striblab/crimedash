<script>
  import { onMount } from 'svelte';
  import Chart from 'chart.js/auto';

  import staffMplsData from '../../store/staff/staff_mpls.json';
  import staffMinneapolisData from '../../store/staff/staff_minneapolis.json';

  let mplsChart, minneapolisChart;

  function createChart(ctx, chartData, title, type = 'line') {
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
            title: {
              display: true,
              text: 'Number of Staff'
            }
          }
        }
      }
    });
  }

  onMount(() => {
    // Chart for staff_mpls.json
    const mplsLabels = staffMplsData.map(item => item.date);
    const mplsDataset = {
      label: 'Sworn Officers',
      data: staffMplsData.map(item => item.officers),
      borderColor: 'rgba(70, 130, 180, 0.8)',
      backgroundColor: 'rgba(70, 130, 180, 0.8)',
      pointRadius: 0,
      fill: false
    };
    const mplsLeave = {
      label: 'On Leave',
      data: staffMplsData.map(item => item.leave),
      borderColor: 'rgb(255, 159, 64)',
      backgroundColor: 'rgba(255, 159, 64, 0.5)',
      pointRadius: 0,
      fill: false
    };

    mplsChart = createChart(document.getElementById('mplsChart').getContext('2d'), {
      labels: mplsLabels,
      datasets: [mplsDataset,mplsLeave]
    }, 'Minneapolis Staff by Month');

    // Chart for staff_minneapolis.json
    const minneapolisLabels = staffMinneapolisData.map(item => item.year.toString());
    const maleOfficers = {
      label: 'Male Officers',
      data: staffMinneapolisData.map(item => item["Male Officers"]),
      borderColor: 'rgb(54, 162, 235)',
      backgroundColor: 'rgba(54, 162, 235, 0.5)',
      fill: false
    };
    const femaleOfficers = {
      label: 'Female Officers',
      data: staffMinneapolisData.map(item => item["Female Officers"]),
      borderColor: 'rgb(255, 99, 132)',
      backgroundColor: 'rgba(255, 99, 132, 0.5)',
      fill: false
    };
    const maleCivilians = {
      label: 'Male Civilians',
      data: staffMinneapolisData.map(item => item["Male Civilians"]),
      borderColor: 'rgb(255, 159, 64)',
      backgroundColor: 'rgba(255, 159, 64, 0.5)',
      fill: false
    };
    const femaleCivilians = {
      label: 'Female Civilians',
      data: staffMinneapolisData.map(item => item["Female Civilians"]),
      borderColor: 'rgb(153, 102, 255)',
      backgroundColor: 'rgba(153, 102, 255, 0.5)',
      fill: false
    };

    minneapolisChart = createChart(document.getElementById('minneapolisChart').getContext('2d'), {
      labels: minneapolisLabels,
      datasets: [maleOfficers, femaleOfficers, maleCivilians, femaleCivilians]
    }, 'Minneapolis Staff by Year');
  });
</script>

<h3>Minneapolis: Police Staffing</h3>

<h4 class="source">Data sources: Minneapolis Police Department</h4>

<p>To date, the Minneapolis Police Department has seen an estimated 40% exodus from its ranks that started in 2020. In recent months, MPD has been netting additional officers to its ranks.</p>

<div class="chart-container">
  <canvas id="mplsChart"></canvas>
</div>
<div class="download"><a href="../../store/staff/staff_mpls.csv">Download 2019-2024 MPD staffing by pay period data</a></div>

<p>&nbsp;</p>

<p>At 1.4 sworn officers to 1,000, MPD currently has among the lowest staffing rations among major American cities, far below the national average.</p>

<div class="download"><a href="../../store/staff/staff_compare.csv">Download police 1985-2022 staffing ratio comparison data</a></div>

<p>&nbsp;</p>

<p>Officers leaving MPD have prodominantly been male, though rates of female departure are higher.</p>

<div class="chart-container">
  <canvas id="minneapolisChart"></canvas>
</div>
<div class="download"><a href="../../store/staff/staff_minneapolis.csv">Download police 1985-2024 staffing breakdown data</a></div>

<p>&nbsp;</p>

<h4>Links</h4>
<ul>
    <li><a href="https://cde.state.mn.us/LawEnforcementEmployeeInformation/LawEnforcementEmployeeInformation">Minnesota LEO employment dashboard</a></li>
    <li><a href="https://cde.ucr.cjis.gov/LATEST/webapp/#/pages/le/pe">FBI Law Enforcement Employment Statistics</a></li>
</ul>

<style>

</style>
