<!-- <script>
  import { onMount } from 'svelte';
  import Papa from 'papaparse';
  import { Bar } from 'svelte-chartjs';
  import {
    Chart as ChartJS,
    BarElement,
    CategoryScale,
    LinearScale,
    Tooltip,
    Legend
  } from 'chart.js';

  ChartJS.register(BarElement, CategoryScale, LinearScale, Tooltip, Legend);

  let crimeData = [];
  let years = [];
  let charts = [];

  const crimes = [
    "Aggravated Assault",
    "All Other Larceny",
    "Animal Cruelty",
    "Arson",
    "Assisting or Promoting Prostitution",
    "Betting Wagering",
    "Bribery",
    "Burglary Breaking Entering",
    "Counterfeiting Forgery",
    "Credit Card Automated Teller Machine Fraud",
    "Destruction Damage Vandalism of Property",
    "Drug Equipment Violations",
    "Drug Narcotic Violations",
    "Embezzlement",
    "Extortion Blackmail",
    "False Pretenses Swindle Confidence Game",
    "Fondling",
    "Gambling Equipment Violation",
    "Hacking Computer Invasion",
    "Human Trafficking Commercial Sex Acts",
    "Human Trafficking Involuntary Servitude",
    "Identity Theft",
    "Impersonation",
    "Incest",
    "Intimidation",
    "Kidnapping Abduction",
    "Motor Vehicle Theft",
    "Murder Non-negligent Manslaughter",
    "Negligent Manslaughter",
    "Operating Promoting Assisting Gambling",
    "Pocket-picking",
    "Pornography Obscene Material",
    "Prostitution",
    "Purchasing Prostitution",
    "Purse-snatching",
    "Rape",
    "Robbery",
    "Sexual Assault With An Object",
    "Shoplifting",
    "Simple Assault",
    "Sodomy",
    "Sports Tampering",
    "Statutory Rape",
    "Stolen Property Offenses",
    "Theft From Building",
    "Theft From Coin Operated Machine or Device",
    "Theft From Motor Vehicle",
    "Theft of Motor Vehicle Parts or Accessories",
    "Weapon Law Violations",
    "Welfare Fraud",
    "Wire Fraud",
    "Group A Total"
  ];

  onMount(async () => {
    const res = await fetch('./store/stpn/NIBRS_StPaul_actual.csv'); // Place file in `static` folder
    const text = await res.text();
    const parsed = Papa.parse(text, { header: true }).data;

    crimeData = parsed.filter(row => row.year); // Remove potential blank rows
    years = [...new Set(crimeData.map(row => row.year))];

    charts = crimes.map(crime => {
      const data = years.map(year => {
        const row = crimeData.find(r => r.year === year);
        return row && row[crime] ? parseInt(row[crime]) : 0;
      });

      return {
        label: crime,
        data,
        options: {
          responsive: true,
          plugins: {
            legend: { display: false },
            title: { display: true, text: crime }
          },
          scales: {
            x: { title: { display: true, text: 'Year' } },
            y: { beginAtZero: true }
          }
        }
      };
    });
  });
</script>



<style>
  .chart-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 1rem;
  }
</style> -->


<h3>St. Paul: NIBRS Statistics</h3>

<h4 class="source">Data sources: St. Paul Police Department, Minnesota Bureau of Criminal Apprehension</h4>

<p>Since 2021, St. Paul's NIBRS criminal offense data has lived on the <a href="https://cde.state.mn.us/">BCA's Crime Data Explorer</a>.</p>

<!-- <div class="chart-grid">
    {#each charts as chart}
      <Bar {chart.options} data={{ labels: years, datasets: [{ label: chart.label, data: chart.data, backgroundColor: '#3366cc' }] }} />
    {/each}
  </div> -->

<div class="download"><a href="../../store/stpn/NIBRS_StPaul_actual.csv">Download St. Paul 2021-present NIBRS offenses</a></div>
<div class="download"><a href="../../store/stpn/NIBRS_StPaul.csv">Download St. Paul 2021-present NIBRS offenses, rates and clearances</a></div>

<h4>Links</h4>


<ul>
    <li><a href="https://information.stpaul.gov/apps/1b00c40c873748e6a42dd9ba9e9f533b/explore">SPPD Crime Data Export Tool</a></li>
    <li><a href="https://information.stpaul.gov/datasets/stpaul::crime-incident-report/explore">SPPD Crime Incident Reports</a></li>
    <li><a href="https://information.stpaul.gov/apps/crime-incidents-by-neighborhood/explore">SPPD Police Incidents</a></li>
    <li><a href="https://saintpaulmn.mycusthelp.com/WEBAPP/_rs/(S(3bgsui0ryccasua2zoohdy5k))/supporthome.aspx">St. Paul DPA requests</a></li>
</ul>