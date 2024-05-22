<script>
	import About from './About.svelte';
	import Murder from './Murder.svelte';
	import Manslaughter from './Manslaughter.svelte';
	import Gunfire from './Gunfire.svelte';
	import Shotvictims from './Shotvictims.svelte';
	import Assault from './Assault.svelte';
	import Domestic from './Domestic.svelte';
	import Rape from './Rape.svelte';
	import Robbery from './Robbery.svelte';
	import Carjack from './Carjack.svelte';
	import Autotheft from './Autotheft.svelte';
	import Burglary from './Burglary.svelte';
	import Larceny from './Larceny.svelte';
	import Arson from './Arson.svelte';
	import Drugs from './Drugs.svelte';
	import Other from './Other.svelte';
	import Activity from './Activity.svelte';
	import Precincts from './Precincts.svelte';
	import Transit from './Transit.svelte';
	import Park from './Park.svelte';
	import UMPD from './UMPD.svelte';
	import MSP from './MSP.svelte';
	import STP from './STP.svelte';
	import Suburbs from './Suburbs.svelte';
	import Statewide from './Statewide.svelte';
	import National from './National.svelte';
	import Arrests from './Arrests.svelte';
	import LEOKA from './LEOKA.svelte';
	import Force from './Force.svelte';
	import Staff from './Staff.svelte';
	import Practices from './Practices.svelte';
  
	let modules = [
	  { id: 'murder', name: 'Minneapolis: Murder', component: Murder },
	  { id: 'manslaughter', name: 'Minneapolis: Manslaughter', component: Manslaughter },
	  { id: 'gunfire', name: 'Minneapolis: Shots Fired',  component: Gunfire },
	  { id: 'shotvictims', name: 'Minneapolis: Shooting Victims',  component: Shotvictims },
	  { id: 'assault', name: 'Minneapolis: Aggravated Assault',  component: Assault },
	  { id: 'domestic', name: '--Minneapolis: Domestic Aggravated Assault',  component: Domestic },
	  { id: 'rape', name: 'Minneapolis: Sex Offenses',  component: Rape },
	  { id: 'robbery', name: 'Minneapolis: Robbery',  component: Robbery },
	  { id: 'carjack', name: '--Minneapolis: Carjacking',  component: Carjack },
	  { id: 'autotheft', name: 'Minneapolis: Motor Vehicle Theft',  component: Autotheft },
	  { id: 'burglary', name: 'Minneapolis: Burglary',  component: Burglary },
	  { id: 'larceny', name: 'Minneapolis: Larceny',  component: Larceny },
	  { id: 'arson', name: 'Minneapolis: Arson',  component: Arson },
	  { id: 'drugs', name: 'Minneapolis: Drug Offenses',  component: Drugs },
	  { id: 'other', name: 'Minneapolis: Other Offenses',  component: Other },
	  { id: 'activity', name: 'Minneapolis: Police Activity',  component: Activity },
	  { id: 'precincts', name: 'Minneapolis: Police Precincts',  component: Precincts },
	  { id: 'staff', name: 'Minneapolis: Police Staffing',  component: Staff },
	  { id: 'park', name: 'Minneapolis: Park Police',  component: Park },
	  { id: 'transit', name: 'Metro Transit Police Department',  component: Transit },
	  { id: 'umpd', name: 'University of Minnesota Police Department',  component: UMPD },
	  { id: 'msp', name: 'MSP Airport Police Department',  component: MSP },
	  { id: 'stp', name: 'St. Paul: Public Safety Trends',  component: STP },
	  { id: 'suburbs', name: 'Suburban Public Safety',  component: Suburbs },
	  { id: 'statewide', name: 'Statewide Public Safety',  component: Statewide },
	  { id: 'arrests', name: 'Statewide Arrests',  component: Arrests },
	  { id: 'leoka', name: 'Statewide LEOKA',  component: LEOKA },
	  { id: 'force', name: 'Statewide Police Use-of-Force',  component: Force },
	  { id: 'national', name: 'National Public Safety',  component: National },
	  { id: 'practices', name: 'Notes & Best Practices',  component: Practices },
	];
  
	let selectedModule = null;
  </script>

  <div id="about"><About /></div>

  
  <div id="wrapper">
	<div style="position: sticky; top: 0; z-index: 10;"></div>
	<select bind:value={selectedModule} style="position: sticky; top: 0; z-index: 9; margin-bottom:20px; width:100%;">
	  <option value={null}>Select a category</option>
	  {#each modules as module}
		<option value={module.id}>{module.name}</option>
	  {/each}
	</select>

	{#each modules as module}
	  {#if module.id === selectedModule}
		<div id={module.id}>
		  <svelte:component this={module.component} />
		  <hr>
		</div>
	  {/if}
	{/each}
  </div>
  
  <style>
	#wrapper, #about{
	  max-width: 800px;
	  margin: auto;
	  font-family: 'Roboto', Arial, Helvetica, sans-serif;
	  font-size: 16px;
	  line-height: 1.6;
	  color: #333;
	}
  </style>
  