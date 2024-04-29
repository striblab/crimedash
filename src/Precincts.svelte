<script>
  import { onMount } from 'svelte';
  import { writable } from 'svelte/store';

    // Store to track the active image for the lightbox
    let activeImage = writable(null);
  
    function openLightbox(image) {
      activeImage.set(image);
    }
  
    function closeLightbox() {
      activeImage.set(null);
    }

</script>


<h3>Minneapolis: Police Precincts</h3>

<h4 class="source">Data sources: Minneapolis Police Department</h4>

<div><p>Minneapolis is divided into five police precincts, for each broad region of the city.</p></div>

<ul>
  <li>First Precinct: Central Minneapolis/Downtown neighborhoods</li>
  <li>Second Precinct: Northeast Minneapolis/University neighborhoods</li>
  <li>Third Precinct: South Minneapolis/Midtown area</li>
  <li>Fourth Precinct: North Side neighborhoods</li>
  <li>Fifth Precinct: Southeast Minneapolis/Uptown area</li>
</ul>

<p>&nbsp;</p>

<h4>Precinct map</h4>

<div class="map-container">
  {#each ['../store/precincts/precincts.jpeg'] as image}
    <img src={image} alt={`gunfire Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
  {/each}
</div>

{#if $activeImage}
<div class="lightbox" on:click={closeLightbox}>
  <img src={$activeImage} alt="Expanded Image">
</div>
{/if}

<p>&nbsp;</p>

<div class="download"><a href="../store/precincts/mpls_precincts.geojson">Download Minneapolis police precincts GEOJSON shapefile</a></div>
<div class="download"><a href="../store/precincts/mpls_neighborhoods.geojson">Download Minneapolis neighborhoods GEOJSON shapefile</a></div>



<h4>Links</h4>
<ul>
  <li><a href="https://tableau.minneapolismn.gov/views/CrimeDashboard/Summary?%3Adisplay_count=n&%3Aiid=5&%3Aorigin=viz_share_link&%3AshowAppBanner=false&%3AshowVizHome=n&%3Atabs=yes&%3Atoolbar=no&%3AisGuestRedirectFromVizportal=y&%3Aembed=y">Minneapolis NIBRS Crime Dashboard</a> | <a href="https://opendata.minneapolismn.gov/datasets/cityoflakes::crime-data/about">raw data</a></li>
</ul>

<style>
 
</style>