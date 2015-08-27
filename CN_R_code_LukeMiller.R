# Excerpt derived from Luke's HMS_temp_var_2014.Rnw analysis file
require(car)

# Load the C:N ratio data from Matt Bracken, derived from plates collected in
# January 2015 at the end of the 2014 experiment. The total of 84 plates were
# the only plates that we could harvest enough microalgae off of to create a
# viable sample, and some of them returned no Carbon, so they are removed.

cn3 = read.csv('2014_summer_CN_ratios_from_Bracken_with_treats.csv')

# Print a table of the number of plates included in each grazer category
cat("Number of plates in each grazing category\n")
table(cn3$LimpetTreat)
# And print a table of the number of limpets on each plate
cat("\n Limpets present on a plate\n")
table(cn3$LimpetTreat,cn3$limpets.present)


levs = table(cn3$LimpetTreat)
require(RColorBrewer)
cols = brewer.pal(7,'Set1')
cols = cols[c(5,7,1,2)] # red, blue, orange, brown
lcols = c(rep(cols[1],levs[1]),rep(cols[2],levs[2]),rep(cols[3],levs[3]),
				rep(cols[4],levs[4]))
lpch = c(rep(17,levs[1]),rep(18,levs[2]),rep(19,levs[3]),rep(20,levs[4]))

# Order cn3 based on LimpetTreat, then CNratio
cn3 = cn3[order(cn3$LimpetTreat,cn3$CNratio),]
lpch = as.character(cn3$limpets.present)
par(mfrow=c(3,1), mar = c(4,11,1,0.2))
dotchart(cn3$CNratio,groups=cn3$LimpetTreat, xlab = 'C:N ratio',
		main = 'Raw data', color = lcols, pch = 20, lcolor = lcols)
dotchart(cn3$av.daily.max, groups = cn3$LimpetTreat, 
		xlab = 'Average daily max. temperature, C',
		color = lcols, lcolor = lcols, pch = 20)
dotchart(cn3$Fo, groups = cn3$LimpetTreat, 
		xlab = 'Algal density, Fo',
		color = lcols, lcolor = lcols, pch = 20)



# Create an orderly spacing of x-locations for each point
levs = table(cn3$LimpetTreat)
locs = c(seq(0.5,1.5,length=levs[1]),
		seq(1.5,2.5,length=levs[2]),
		seq(2.5,3.5,length=levs[3]),
		seq(3.5,4.5,length=levs[4]))

par(mfrow = c(2,1), mar = c(4,5,1,0.2))

# Plot the CN ratio raw data for each group, ordered in terms of increasing 
# C:N value. The plotting symbol will be the number of limpets present initially
plot(x = locs[order(locs)], cn3$CNratio,
		xlab = '', xaxt = 'n', yaxt = 'n', type = 'n',
		ylab = 'C:N ratio', las = 1, col = lcols,
		main = "Initial number of limpets")
abline(h = 10, col = 'grey80', lty = 2)
# Plot original density
text(x = locs[order(locs)], cn3$CNratio, 
		label = as.character(cn3$Density),
		col = lcols)
axis(side = 1, at = seq(1,4), labels = levels(cn3$LimpetTreat))
axis(side = 2, at = c(10,20,40,60,80), labels = c(10,20,40,60,80), las = 1)


# Plot the CN ratio raw data for each group, ordered in terms of increasing 
# C:N value. The plotting symbol will be the number of limpets present on the
# plate at the end of the experiment. 
plot(x = locs[order(locs)], cn3$CNratio,
		xlab = '', xaxt = 'n', yaxt = 'n', type = 'n',
		ylab = 'C:N ratio', las = 1, col = lcols, 
		main = "Limpets remaining")
abline(h = 10, col = 'grey80', lty = 2)
# Plot number of limpets remaining at end of experiment
text(x = locs[order(locs)], cn3$CNratio, 
		label = as.character(cn3$limpets.present),
		col = lcols)
axis(side = 1, at = seq(1,4), labels = levels(cn3$LimpetTreat))
axis(side = 2, at = c(10,20,40,60,80), labels = c(10,20,40,60,80), las = 1)

###########################################################################
###########################################################################
# Fit a 3-way model with LimpetTreat, av.daily.max (temperature), and 
# algal density (Fo)
c8 = lm(log(CNratio)~LimpetTreat*av.daily.max*Fo, data = cn3)
c8a = update(c8,.~.-LimpetTreat:av.daily.max:Fo);
c8b=update(c8a,.~.-av.daily.max:Fo);
c8c=update(c8b,.~.-LimpetTreat:Fo);
c8d=update(c8c,.~.-LimpetTreat:av.daily.max);
c8e=update(c8d,.~.-av.daily.max);
c8f=update(c8e,.~.-Fo)
c8g=update(c8f,.~.-LimpetTreat)
anova(c8,c8a,c8b,c8c,c8d,c8e,c8f,c8g)
cat('\n-------------------------------------------------\n')
cat('Below, (Intercept) represents the estimate for the baseline No Grazers treatment\n')
# Keep Fo and LimpetTreat as main effects
summary(c8e)
cat('\n-------------------------------------------------\n')
Anova(c8e, type = '3')
cat('\n-------------------------------------------------\n')
summary(glht(c8e,linfct = mcp(LimpetTreat = 'Tukey')))
cld(glht(c8e,linfct = mcp(LimpetTreat = 'Tukey')))

# Diagnostic plots for the lm model
par(mfrow = c(2,2))
plot(c8e)

# Effects plots for the lm model
plot(allEffects(c8e))

###########################################################################
###########################################################################
# Bootstrapped run of the lm model to see if a non-parametric approach changes
# the outcome noticeably. 
boot.cn = Boot(c8e, f=coef, labels=labels(coef(c8e)), R=9999, method='case')


cat("Bootstrapped coefficient estimates, with original parametric estimates
in the 'original' column:\n")
summary(boot.cn, high.moments=FALSE)
cat('\n-------------------------------------------------\n')
cat("Bootstrapped confidence intervals\n")
confint(boot.cn,level=.95,type='bca')

hist(boot.cn, las = 1)
