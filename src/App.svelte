<script>
	import { onMount } from 'svelte';
	import About from './About.svelte';
	import Murder from './Murder.svelte';
	import Manslaughter from './Manslaughter.svelte';
	import Justified from './Justified.svelte';
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
	import Conduct from './Conduct.svelte';
	import Transit from './Transit.svelte';
	import Park from './Park.svelte';
	import UMPD from './UMPD.svelte';
	import MSP from './MSP.svelte';
	import STPF from './STPF.svelte';
	import STPB from './STPB.svelte';
	import STPM from './STPM.svelte';
	import STPS from './STPS.svelte';
	import STPAT from './STPAT.svelte';
	import STPR from './STPR.svelte';
	import STPSA from './STPSA.svelte';
	import STPL from './STPL.svelte';
	import STPA from './STPA.svelte';
	import STPPA from './STPPA.svelte';
	import STPN from './STPN.svelte';
	import Hennepin from './Hennepin.svelte';
	import Ramsey from './Ramsey.svelte';
	import Anoka from './Anoka.svelte';
	import Scott from './Scott.svelte';
	import Carver from './Carver.svelte';
	import Dakota from './Dakota.svelte';
	import Washington from './Suburbs.svelte';
	import Statewide from './Statewide.svelte';
	import National from './National.svelte';
	import Arrests from './Arrests.svelte';
	import LEOKA from './LEOKA.svelte';
	import Force from './Force.svelte';
	import Staff from './Staff.svelte';
	import Practices from './Practices.svelte';
	import Courts from './Courts.svelte';
	import Links from './Links.svelte';
  
	let modules = [
	  { id: 'murder', cat: 'Minneapolis', name: 'Murder', component: Murder },
	  { id: 'manslaughter', cat: 'Minneapolis', name: 'Manslaughter', component: Manslaughter },
	  { id: 'justified', cat: 'Minneapolis', name: 'Justifiable Homicide', component: Justified },
	  { id: 'gunfire', cat: 'Minneapolis', name: 'Shots Fired', component: Gunfire },
	  { id: 'shotvictims', cat: 'Minneapolis', name: 'Shooting Victims', component: Shotvictims },
	  { id: 'assault', cat: 'Minneapolis', name: 'Aggravated Assault', component: Assault },
	  { id: 'domestic', cat: 'Minneapolis', name: 'Domestic Aggravated Assault', component: Domestic },
	  { id: 'rape', cat: 'Minneapolis', name: 'Sex Offenses', component: Rape },
	  { id: 'robbery', cat: 'Minneapolis', name: 'Robbery', component: Robbery },
	  { id: 'carjack', cat: 'Minneapolis', name: 'Carjacking', component: Carjack },
	  { id: 'autotheft', cat: 'Minneapolis', name: 'Motor Vehicle Theft', component: Autotheft },
	  { id: 'burglary', cat: 'Minneapolis', name: 'Burglary', component: Burglary },
	  { id: 'larceny', cat: 'Minneapolis', name: 'Larceny', component: Larceny },
	  { id: 'arson', cat: 'Minneapolis', name: 'Arson', component: Arson },
	  { id: 'drugs', cat: 'Minneapolis', name: 'Drug Offenses', component: Drugs },
	  { id: 'other', cat: 'Minneapolis', name: 'Other Offenses', component: Other },
	  { id: 'activity', cat: 'Minneapolis', name: 'Police Activity', component: Activity },
	  { id: 'precincts', cat: 'Minneapolis', name: 'Police Precincts', component: Precincts },
	  { id: 'conduct', cat: 'Minneapolis', name: 'Officer Conduct', component: Conduct },
	  { id: 'staff', cat: 'Minneapolis', name: 'Police Staffing', component: Staff },
	  { id: 'park', cat: 'Minneapolis', name: 'Park Police', component: Park },
	  { id: 'stpm', cat: 'St. Paul', name: 'Homicides', component: STPM },
	  { id: 'stps', cat: 'St. Paul', name: 'Shootings', component: STPS },
	  { id: 'stpr', cat: 'St. Paul', name: 'Robbery', component: STPR },
	  { id: 'stpsa', cat: 'St. Paul', name: 'Rape', component: STPSA },
	  { id: 'stpa', cat: 'St. Paul', name: 'Aggravated Assault', component: STPA },
	  { id: 'stpl', cat: 'St. Paul', name: 'Larceny', component: STPL },
	  { id: 'stpb', cat: 'St. Paul', name: 'Burglary', component: STPB },
	  { id: 'stpat', cat: 'St. Paul', name: 'Motor Vehicle Theft', component: STPAT },
	  { id: 'stpf', cat: 'St. Paul', name: 'Arson', component: STPF },
	  { id: 'stpn', cat: 'St. Paul', name: 'NIBRS Statistics', component: STPN },
	  { id: 'stppa', cat: 'St. Paul', name: 'Police Activity', component: STPPA },
	  { id: 'umpd', cat: 'Metro', name: 'University of Minnesota Police Department', component: UMPD },
	  { id: 'transit', cat: 'Metro', name: 'Metro Transit Police Department', component: Transit },
	  { id: 'msp', cat: 'Metro', name: 'MSP Airport Police Department', component: MSP },
	  { id: 'subhennepin', cat: 'Metro', name: 'Hennepin County', component: Hennepin },
	  { id: 'subramsey', cat: 'Metro', name: 'Ramsey County', component: Ramsey },
	  { id: 'subdakota', cat: 'Metro', name: 'Dakota County', component: Dakota },
	  { id: 'subanoka', cat: 'Metro', name: 'Anoka County', component: Anoka },
	  { id: 'subscott', cat: 'Metro', name: 'Scott County', component: Scott },
	  { id: 'subcarver', cat: 'Metro', name: 'Carver County', component: Carver },
	  { id: 'subwash', cat: 'Metro', name: 'Washington County', component: Washington },
	  { id: 'statewide', cat: 'Minnesota', name: 'Statewide Public Safety Trends', component: Statewide },
	  { id: 'arrests', cat: 'Minnesota', name: 'Arrests', component: Arrests },
	  { id: 'leoka', cat: 'Minnesota', name: 'LEOKA', component: LEOKA },
	  { id: 'force', cat: 'Minnesota', name: 'Police Use-of-Force', component: Force },
	  { id: 'courts', cat: 'Minnesota', name: 'Minnesota Courts', component: Courts },
	  { id: 'national', cat: 'National', name: 'National Public Safety Trends', component: National },
	  { id: 'practices', cat: 'Notes', name: 'Best Practices', component: Practices },
	  { id: 'links', cat: 'Notes', name: 'Other Links', component: Links },
	];
  
	// Grouping modules by category
	let groupedModules = {};
	modules.forEach(module => {
	  if (!groupedModules[module.cat]) {
		groupedModules[module.cat] = [];
	  }
	  groupedModules[module.cat].push(module);
	});
  
	let selectedModule = null;
  
	function changeURL(value) {
	  let queryParams = new URLSearchParams(window.location.search);
	  queryParams.set("s", value);
	  history.replaceState(null, null, "?" + queryParams.toString());
	}
  
	onMount(() => {
	  let params = new URLSearchParams(window.location.search);
	  selectedModule = params.get('s');
	});
  </script>

  <div id="about"><About /></div>

  
  <div id="wrapper">
	<div style="position: sticky; top: 0; z-index: 10;"></div>
	<select bind:value={selectedModule} style="position: sticky; top: 0; z-index: 9; margin-bottom:20px; width:100%;">
		<option value={null}>Select a category</option>
		
		{#each Object.entries(groupedModules) as [category, modules]}
		  <optgroup label={category}>
			{#each modules as module}
			  <option value={module.id}>{module.name}</option>
			{/each}
		  </optgroup>
		{/each}
	  </select>

	{#each modules as module}
	  {#if module.id === selectedModule}
		<div id={module.id}>
		  <div style="display:none">{changeURL(module.id)}</div>
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
  