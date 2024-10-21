<script>
  import { onMount } from 'svelte';
  // import localTimestamp from './data/timestamp.txt';

  // console.log(localTimestamp)

  // document.getElementById('timestamp').textContent = "Updated " + localTimestamp;

  onMount(() => {
    fetch('../store/timestamp.txt')
    .then(response => response.text())
    .then(data => {
      const date = new Date(data);
      const options = {
        month: 'long',
        day: 'numeric',
        year: 'numeric',
        hour: 'numeric',
        minute: '2-digit',
        hour12: true
      };
      let formattedDate = date.toLocaleString('en-US', options);
      formattedDate = formattedDate.replace("AM", "a.m.").replace("PM", "p.m.");

      console.log(formattedDate);
        document.getElementById('timestamp').textContent = `Updated ` + formattedDate;
    })
    .catch(error => console.error('Failed to fetch timestamp:', error));

  });
</script>

<h1>Tracking Minnesota public safety trends</h1>

<p class="article-byline">Developed and managed by <a class="byline" href="https://www.startribune.com/jeff-hargarten/6370579/">Jeff Hargarten</a></p><span>Star Tribune</span>

<p id="timestamp" class="timestamp"></p>

<p>Welcome to The Minnesota Star Tribune Public Safety Dashboard. Use this to browse crime, policing and other public safety statistics for Minneapolis and elsewhere in Minnesota. Data is updated Mondays, Wednesdays and Fridays. See the <a href="https://github.com/striblab/20240428-crimedash">the Github repo</a> for more documentation. <a href="mailto:jeff.hargarten@startribune.com">Email</a> or Slack any questions or issues to Jeff Hargarten.</p>

<p>Also see <a href="https://static.startribune.com/news/projects/all/20230702-tcmap/">the Star Tribune Placefinder</a> to pinpoint what Twin Cities neighborhood an address lands in.</p>
  
<p>The Star Tribune's <a href="https://www.startribune.com/every-police-involved-death-in-minnesota-since-2000/502088871/">Fatal Police Encounters</a> database details officer-involved killings since 2000.</p>

<div class="disclaimer"><p>DISCLAIMER: This isn't meant for external use outside the Star Tribune newsroom. All provided statistics should be double-checked in case of data ingestion errors.</p></div>

<style>
.byline {
  color: #000;
  text-decoration: none;
  font-weight:bold;
}
.timestamp {
  color:#cccccc;
}
p a {
    color: #228B22;
    text-decoration: none;
}
p a:hover, p a:focus {
    color: #006400;
    text-decoration: underline;
}
</style>
