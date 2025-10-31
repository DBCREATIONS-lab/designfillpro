# SUPER SIMPLE DOMAIN SETUP
## Get designfillpro.com working in 5 minutes!

### STEP 1: Netlify (Add Custom Domain)
**Go to:** https://app.netlify.com/sites/starlit-naiad-1f5971/settings/domain

1. Click "Add custom domain"
2. Type: `designfillpro.com`
3. Click "Add domain"
4. Repeat for: `www.designfillpro.com`

### STEP 2: GoDaddy DNS Records
**Go to:** https://dcc.godaddy.com/manage/designfillpro.com/dns

**DELETE all existing A records, then ADD these 3 records:**

**Record 1:**
- Type: A
- Name: @
- Value: `75.2.60.5`

**Record 2:**
- Type: A
- Name: @
- Value: `99.83.190.102`

**Record 3:**
- Type: CNAME
- Name: www
- Value: `starlit-naiad-1f5971.netlify.app`

### DONE! 
Wait 15 minutes to 2 hours for DNS to update.
Then designfillpro.com = your awesome Design Fill Pro! 🚀

### Quick Copy-Paste Values:
```
75.2.60.5
99.83.190.102
starlit-naiad-1f5971.netlify.app
```