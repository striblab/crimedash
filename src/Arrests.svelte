<script>
  import { onMount } from 'svelte';
  import Chart from 'chart.js/auto';
  import arrests from '../store/arrests/arrests.json';

  let arrestsChart;

  function createChart(ctx, chartData, title, type = 'line') {
      return new Chart(ctx, {
      type: type,
      data: {
          labels: chartData.map(item => item.year.toString()),
          datasets: [{
          label: title,
          data: chartData.map(item => item.incidents), 
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
              text: ' '
              }
          }
          }
      }
      });
  }

  onMount(() => {
      const ctxArrests = document.getElementById('arrestsChart').getContext('2d');
      arrestsChart = createChart(ctxArrests, arrests, 'Statewide Arrests');
  });
</script>
<h3>Minnesota Arrests</h3>

<h4 class="source">Data sources: Minnesota Bureau of Criminal Apprehension</h4>

<p>Volumes of arrests across Minnesota have been declining for years.</p>

<div class="chart-container">
  <canvas id="arrestsChart"></canvas>
</div>
<div class="download"><a href="../store/arrests/arrests.xlsx">Download Minnesota arrests data, 2004-2023</a></div>

<p>&nbsp;</p>

<p>Arrest counts can be found in the annual Minnesota Uniform Crime Report from the BCA. Since 2021, under NIBRS, comparable arrest counts are listed under Group A Arrests.</p>

<p>Granulated arrest data is hard to come by, but a lot of broad statistics are available from the BCA. Here are the most recent arrest sheets available:</p>

<div class="download">
  <a href="../store/arrests/ArrestsByJudicialDistrictDownloadDataReportYear2025.xlsx">Arrests by Judicial District 2025</a>
</div>
<div class="download">
    <a href="../store/arrests/ArrestsByJudicialDistrictDownloadDataReportYear2024.xlsx">Arrests by Judicial District 2024</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsByJudicialDistrictDownloadDataReportYear2023.xlsx">Arrests by Judicial District 2023</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsByJudicialDistrictDownloadDataReportYear2022.xlsx">Arrests by Judicial District 2022</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsByJudicialDistrictDownloadDataReportYear2021.xlsx">Arrests by Judicial District 2021</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsDrugByAgencyDownloadDataReportYear2021.xlsx">Drug Arrests by Agency 2021</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsDrugByAgencyDownloadDataReportYear2022.xlsx">Drug Arrests by Agency 2022</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsDrugByAgencyDownloadDataReportYear2023.xlsx">Drug Arrests by Agency 2023</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsDrugByAgencyDownloadDataReportYear2025.xlsx">Drug Arrests by Agency 2025</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsDrugByAgencyDownloadDataReportYear2024.xlsx">Drug Arrests by Agency 2024</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsDrugByCountyDownloadDataReportYear2021.xlsx">Drug Arrests by County 2021</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsDrugByCountyDownloadDataReportYear2022.xlsx">Drug Arrests by County 2022</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsDrugByCountyDownloadDataReportYear2023.xlsx">Drug Arrests by County 2023</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsDrugByCountyDownloadDataReportYear2024.xlsx">Drug Arrests by County 2024</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupAByAgeSexDownloadDataReportYear2021.xlsx">Group A Arrests by Age and Sex 2021</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupAByAgeSexDownloadDataReportYear2022.xlsx">Group A Arrests by Age and Sex 2022</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupAByAgeSexDownloadDataReportYear2023.xlsx">Group A Arrests by Age and Sex 2023</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupAByAgeSexDownloadDataReportYear2024.xlsx">Group A Arrests by Age and Sex 2024</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupAByAgeSexDownloadDataReportYear2025.xlsx">Group A Arrests by Age and Sex 2025</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupAByAgeSexCountyDownloadDataReportYear2021.xlsx">Group A Arrests by Age, Sex, and County 2021</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupAByAgeSexCountyDownloadDataReportYear2022.xlsx">Group A Arrests by Age, Sex, and County 2022</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupAByAgeSexCountyDownloadDataReportYear2023.xlsx">Group A Arrests by Age, Sex, and County 2023</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupAByAgeSexCountyDownloadDataReportYear2024.xlsx">Group A Arrests by Age, Sex, and County 2024</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupAByAgeSexCountyDownloadDataReportYear2025.xlsx">Group A Arrests by Age, Sex, and County 2025</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsAdultJuvenileGroupAByAgeRaceDownloadDataReportYear2021.xlsx">Adult and Juvenile Group A Arrests by Age and Race 2021</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsAdultJuvenileGroupAByAgeRaceDownloadDataReportYear2022.xlsx">Adult and Juvenile Group A Arrests by Age and Race 2022</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsAdultJuvenileGroupAByAgeRaceDownloadDataReportYear2023.xlsx">Adult and Juvenile Group A Arrests by Age and Race 2023</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsAdultJuvenileGroupAByAgeRaceDownloadDataReportYear2024.xlsx">Adult and Juvenile Group A Arrests by Age and Race 2024</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsAdultJuvenileGroupAByAgeRaceDownloadDataReportYear2025.xlsx">Adult and Juvenile Group A Arrests by Age and Race 2025</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupBByAgeSexDownloadDataReportYear2021.xlsx">Group B Arrests by Age and Sex 2021</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupBByAgeSexDownloadDataReportYear2022.xlsx">Group B Arrests by Age and Sex 2022</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupBByAgeSexDownloadDataReportYear2023.xlsx">Group B Arrests by Age and Sex 2023</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupBByAgeSexDownloadDataReportYear2024.xlsx">Group B Arrests by Age and Sex 2024</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupBByAgeSexDownloadDataReportYear2025.xlsx">Group B Arrests by Age and Sex 2025</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupBByAgeSexCountyDownloadDataReportYear2021.xlsx">Group B Arrests by Age, Sex, and County 2021</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupBByAgeSexCountyDownloadDataReportYear2022.xlsx">Group B Arrests by Age, Sex, and County 2022</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupBByAgeSexCountyDownloadDataReportYear2023.xlsx">Group B Arrests by Age, Sex, and County 2023</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupBByAgeSexCountyDownloadDataReportYear2024.xlsx">Group B Arrests by Age, Sex, and County 2024</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsGroupBByAgeSexCountyDownloadDataReportYear2025.xlsx">Group B Arrests by Age, Sex, and County 2025</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsAdultJuvenileGroupBByAgeRaceDownloadDataReportYear2021.xlsx">Adult and Juvenile Group B Arrests by Age and Race 2021</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsAdultJuvenileGroupBByAgeRaceDownloadDataReportYear2022.xlsx">Adult and Juvenile Group B Arrests by Age and Race 2022</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsAdultJuvenileGroupBByAgeRaceDownloadDataReportYear2023.xlsx">Adult and Juvenile Group B Arrests by Age and Race 2023</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsAdultJuvenileGroupBByAgeRaceDownloadDataReportYear2024.xlsx">Adult and Juvenile Group B Arrests by Age and Race 2024</a>
  </div>
  <div class="download">
    <a href="../store/arrests/ArrestsAdultJuvenileGroupBByAgeRaceDownloadDataReportYear2025.xlsx">Adult and Juvenile Group B Arrests by Age and Race 2025</a>
  </div>

<h4>Links</h4>
<ul>
    <li><a href="https:/cde.state.mn.us/">Minnesota Crime Data Explorer</a></li>
</ul>

<style>

</style>
