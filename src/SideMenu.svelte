<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';

    export const currentSection = writable('');
    let isScrolling = false;

    const sections = [
        { id: 'about', name: 'About' },
        { id: 'murder', name: 'MPLS:Homicide' },
        { id: 'gunfire', name: 'MPLS:Gunfire' },
        { id: 'assault', name: 'MPLS:Aggravated Assault' },
        { id: 'rape', name: 'MPLS:Rape' },
        { id: 'robbery', name: 'MPLS:Robbery' },
        { id: 'carjack', name: 'MPLS:Carjacking' },
        { id: 'autotheft', name: 'MPLS:Auto Theft' },
        { id: 'burglary', name: 'MPLS:Burglary' },
        { id: 'larceny', name: 'MPLS:Larceny' },
        { id: 'arson', name: 'MPLS:Arson' },
        { id: 'drugs', name: 'MPLS:Drugs' },
        { id: 'other', name: 'MPLS:Other' },
        { id: 'activity', name: 'MPLS:Activity' },
        { id: 'stp', name: 'St. Paul' },
        { id: 'suburbs', name: 'Suburbs' },
        { id: 'statewide', name: 'Statewide' },
        { id: 'national', name: 'National' },
        { id: 'leoka', name: 'LEOKA' },
        { id: 'force', name: 'Force-use' },
        { id: 'staff', name: 'Staffing' }
    ];


    function setCurrentSection(id, shouldScroll = false) {
        if (isScrolling) return; // Prevent new scrolls if already scrolling
        currentSection.set(id);

        if (shouldScroll) {
            isScrolling = true; // Set flag to indicate scrolling has started
            document.getElementById(id)?.scrollIntoView({
                behavior: 'smooth',
                block: 'start',
            });

            // Reset scrolling flag after a delay, assuming scroll ends
            setTimeout(() => {
                isScrolling = false;
            }, 500); // Adjust delay as necessary based on scroll duration
        }
    }

    onMount(() => {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach((entry) => {
                if (entry.isIntersecting && !isScrolling) {
                    currentSection.set(entry.target.id);
                }
            });
        }, { threshold: [0.1] });

        sections.forEach(({ id }) => {
            observer.observe(document.getElementById(id));
        });

        return () => {
            sections.forEach(({ id }) => {
                const el = document.getElementById(id);
                if (el) observer.unobserve(el);
            });
        };
    });
</script>

<nav class="side-menu">

<details>
<summary></summary>
    <ul>
        {#each sections as { id, name }}
            <li>
                <a href="javascript:void(0)"
                   on:click={() => setCurrentSection(id, true)}
                   class:active={$currentSection === id}>
                    {name}
                </a>
            </li>
        {/each}
    </ul>
</details>
</nav>


<style>
    .side-menu {
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 1000;
        background-color: #f9f9f9;
        padding: 10px;
        border-radius: 8px;
        font-size: 14px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }
    .side-menu ul {
        list-style: none;
        margin: 0;
        padding: 0;
    }
    .side-menu ul li a {
        text-decoration: none;
        color: black;
        display: block;
        padding: 6px;
    }
    .side-menu ul li a.active {
        color: white;
        background-color: #228B22;
        border-radius: 4px;
    }

    @media (max-width: 768px) {
        .side-menu {
            display: none;
        }
    }
</style>
