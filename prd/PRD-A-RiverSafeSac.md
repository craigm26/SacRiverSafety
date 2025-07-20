# PRD-A · SacRiverSafety.com

## 1. Purpose
Create a data‑driven, mobile‑friendly static website that consolidates drowning statistics, live river conditions, safety resources, and community stories for the Sacramento & American River corridor.

## 2. Goals
- ↓ ​drowning incidents by making life‑saving info easy to find & share
- Present authoritative, up‑to‑date numbers (Coroner stats + USGS gauges)
- Offer quick‑action widgets (borrow-a‑PFD map, donate buttons, printable flyers)
- Deploy entirely serverless on DigitalOcean's free Static‑Site tier (App Platform)

## 3. Non‑Goals
- No user accounts / log‑in
- No comment threads or forums (link back to r/Sacramento for discussion)
- No paid ads or tracking beyond privacy‑respecting analytics

## 4. Users & JTBDs
| Persona | "Job‑to‑Be‑Done" |
|---------|------------------|
| Local parent planning a river day | Confirm water flow & where to borrow life‑jackets |
| Tubing student | Understand hidden hazards & recent fatalities |
| Journalist / policymaker | Quote yearly drowning totals with source links |

## 5. Core Features
1. **Hero + last‑year fatality count** (auto‑updates each January)
2. **Why Rivers Kill** explainer (currents, cold‑shock, debris, alcohol)
3. **Year‑by‑Year Chart** (2010‑current, stacked accidental vs. homicide/suicide)
4. **Incident Map** with story pop‑ups (Leaflet)
5. **Live River Conditions** widget  
   - USGS 11446500 (American @ Fair Oaks)  
   - USGS 11447650 (Sacramento @ Downtown)  
   - Colour‑coded risk thresholds
6. **Life‑Jacket Loaner Stations** list & map
7. **How to Help** (donate, volunteer, printable PDF flyer)
8. **About/Data Methodology** with open‑data links

## 6. Data Pipeline
| File | Update cadence | Source |
|------|----------------|--------|
| `/data/sac_coroner.csv` | Quarterly GitHub Action | Sac County Coroner table (web scrape) |
| `/data/incidents.yaml` | Manual, ad‑hoc | KCRA, SacBee, Reddit posts |
| Live gauges | Client‑side fetch on page‑load | `waterservices.usgs.gov` JSON |

GitHub Action `pull-data.yml` runs cron `0 4 1 */3 *` (1st of Jan/Apr/Jul/Oct).

## 7. Tech Stack
- **Astro** 4.x (SSG, MDX islands)
- Tailwind CSS + LightningCSS
- Chart.js via `client:only`
- Leaflet + Mapbox tiles (free tier)
- GitHub Actions (build & data scrape)
- DigitalOcean App Platform (Starter / static)
- Plausible self‑hosted analytics

## 8. Deployment
```yaml
# .do/app.yaml
name: riversafe-sac
services:
  - static_sites:
      name: web
      github:
        repo: <owner>/riversafe-sac
        branch: main
      build_command: npm ci && npm run build
      output_dir: dist
envs:
  - key: NODE_VERSION
    value: "20"
```

## 9. Open Source Contributions
This project welcomes open source contributions and will be hosted on DigitalOcean.com. Key areas for community involvement:

### Development
- Data visualization improvements
- Mobile UI/UX enhancements
- Accessibility improvements
- Performance optimizations

### Content & Data
- Incident reporting and verification
- Safety resource updates
- Community story submissions
- Translation/localization

### Infrastructure
- CI/CD pipeline improvements
- Monitoring and analytics
- Security enhancements
- Documentation updates

### Contribution Guidelines
- Fork the repository
- Create feature branches
- Submit pull requests with clear descriptions
- Follow existing code style and conventions
- Include tests for new features
- Update documentation as needed

## 10. Success Metrics
- **Primary**: Reduction in drowning incidents in Sacramento County
- **Secondary**: Website traffic and engagement metrics
- **Tertiary**: Community adoption of safety resources
- **Technical**: Site performance, uptime, and data accuracy
