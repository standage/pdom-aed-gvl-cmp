#!/usr/bin/env Rscript

r11_v_p12a <- read.table("pdom-r11-v-p12a.aed-gaeval.txt", header=TRUE, sep="\t")
r11_v_p12b <- read.table("pdom-r11-v-p12b.aed-gaeval.txt", header=TRUE, sep="\t")

r11a <- r11_v_p12a[r11_v_p12a$Version == "r11" ,]
p12a <- r11_v_p12a[r11_v_p12a$Version == "p12a",]
r11b <- r11_v_p12b[r11_v_p12b$Version == "r11" ,]
p12b <- r11_v_p12b[r11_v_p12b$Version == "p12b",]

png("aed-int-corr-r11.png", width=1200, height=1200, res=150)
plot(r11a$AED, r11a$Integrity, main="", xlab="Annotation Edit Distance (Maker)",
     ylab="Integrity (GAEVAL)", col="blue")
d <- dev.off()
png("aed-int-corr-p12a.png", width=1200, height=1200, res=150)
plot(p12a$AED, p12a$Integrity, main="", xlab="Annotation Edit Distance (Maker)",
     ylab="Integrity (GAEVAL)", col="red")
d <- dev.off()
png("aed-int-corr-p12b.png", width=1200, height=1200, res=150)
plot(p12b$AED, p12b$Integrity, main="", xlab="Annotation Edit Distance (Maker)",
     ylab="Integrity (GAEVAL)", col="#009900")
d <- dev.off()

r11.aed.h <- hist(r11a$AED, plot=FALSE, breaks=20)
r11.snap.aed.h <- hist(r11a$AED[r11a$AbInit == "snap"], plot=FALSE, breaks=20)
p12a.aed.h <- hist(p12a$AED, plot=FALSE, breaks=20)
p12a.snap.aed.h <- hist(p12a$AED[p12a$AbInit == "snap"], plot=FALSE, breaks=20)
p12b.aed.h <- hist(p12b$AED, plot=FALSE, breaks=20)
p12b.snap.aed.h <- hist(p12b$AED[p12b$AbInit == "snap"], plot=FALSE, breaks=20)

png("aed-dist.png", width=1200, height=1200, res=150)
plot(p12a.aed.h$mids, p12a.aed.h$counts, type="l", col="red", main="",
     xlab="Annotation edit distance", ylab="mRNAs", ylim=c(0, 3300))
lines(p12a.snap.aed.h$mids, p12a.snap.aed.h$counts, col="red", lty=2)
lines(p12b.aed.h$mids,      p12b.aed.h$counts,      col="#009900")
lines(p12b.snap.aed.h$mids, p12b.snap.aed.h$counts, col="#009900", lty=2)
lines(r11.aed.h$mids,      r11.aed.h$counts,      col="blue")
lines(r11.snap.aed.h$mids, r11.snap.aed.h$counts, col="blue", lty=2)
d <- dev.off()


r11a.uniq.aed.h <- hist(r11a$AED[r11a$Unique == "yes"], plot=FALSE, breaks=20)
r11a.uniq.snap.aed.h <- hist(r11a$AED[r11a$Unique == "yes" & r11a$AbInit == "snap"], plot=FALSE, breaks=20)
p12a.uniq.aed.h <- hist(p12a$AED[p12a$Unique == "yes"], plot=FALSE, breaks=20)
p12a.uniq.snap.aed.h <- hist(p12a$AED[p12a$Unique == "yes" & p12a$AbInit == "snap"], plot=FALSE, breaks=20)

png("aed-uniq-dist-r11-v-p12a.png", width=1200, height=1200, res=150)
plot(p12a.uniq.aed.h$mids, p12a.uniq.aed.h$counts, type="l", col="red", main="",
     xlab="Annotation edit distance", ylab="mRNAs", ylim=c(0, 400))
lines(p12a.uniq.snap.aed.h$mids, p12a.uniq.snap.aed.h$counts, col="red", lty=2)
lines(r11a.uniq.aed.h$mids,      r11a.uniq.aed.h$counts,      col="blue")
lines(r11a.uniq.snap.aed.h$mids, r11a.uniq.snap.aed.h$counts, col="blue", lty=2)
d <- dev.off()

r11b.uniq.aed.h <- hist(r11b$AED[r11b$Unique == "yes"], plot=FALSE, breaks=20)
r11b.uniq.snap.aed.h <- hist(r11b$AED[r11b$Unique == "yes" & r11b$AbInit == "snap"], plot=FALSE, breaks=20)
p12b.uniq.aed.h <- hist(p12b$AED[p12b$Unique == "yes"], plot=FALSE, breaks=20)
p12b.uniq.snap.aed.h <- hist(p12b$AED[p12b$Unique == "yes" & p12b$AbInit == "snap"], plot=FALSE, breaks=20)

png("aed-uniq-dist-r11-v-p12b.png", width=1200, height=1200, res=150)
plot(p12b.uniq.aed.h$mids, p12b.uniq.aed.h$counts, type="l", col="#009900", main="",
     xlab="Annotation edit distance", ylab="mRNAs", ylim=c(0, 400))
lines(p12b.uniq.snap.aed.h$mids, p12b.uniq.snap.aed.h$counts, col="#009900", lty=2)
lines(r11b.uniq.aed.h$mids,      r11b.uniq.aed.h$counts,      col="blue")
lines(r11b.uniq.snap.aed.h$mids, r11b.uniq.snap.aed.h$counts, col="blue", lty=2)
d <- dev.off()

r11.int.h <- hist(r11a$Integrity, plot=FALSE, breaks=20)
r11.snap.int.h <- hist(r11a$Integrity[r11a$AbInit == "snap"], plot=FALSE, breaks=20)
p12a.int.h <- hist(p12a$Integrity, plot=FALSE, breaks=20)
p12a.snap.int.h <- hist(p12a$Integrity[p12a$AbInit == "snap"], plot=FALSE, breaks=20)
p12b.int.h <- hist(p12b$Integrity, plot=FALSE, breaks=20)
p12b.snap.int.h <- hist(p12b$Integrity[p12b$AbInit == "snap"], plot=FALSE, breaks=20)

png("int-dist.png", width=1200, height=1200, res=150)
plot(p12a.int.h$mids, p12a.int.h$counts, type="l", col="red", main="",
     xlab="Integrity score", ylab="mRNAs", ylim=c(0, 3300))
lines(p12a.snap.int.h$mids, p12a.snap.int.h$counts, col="red", lty=2)
lines(p12b.int.h$mids,      p12b.int.h$counts,      col="#009900")
lines(p12b.snap.int.h$mids, p12b.snap.int.h$counts, col="#009900", lty=2)
lines(r11.int.h$mids,      r11.int.h$counts,      col="blue")
lines(r11.snap.int.h$mids, r11.snap.int.h$counts, col="blue", lty=2)
d <- dev.off()

r11a.uniq.int.h <- hist(r11a$Integrity[r11a$Unique == "yes"], plot=FALSE, breaks=20)
r11a.uniq.snap.int.h <- hist(r11a$Integrity[r11a$Unique == "yes" & r11a$AbInit == "snap"], plot=FALSE, breaks=20)
p12a.uniq.int.h <- hist(p12a$Integrity[p12a$Unique == "yes"], plot=FALSE, breaks=20)
p12a.uniq.snap.int.h <- hist(p12a$Integrity[p12a$Unique == "yes" & p12a$AbInit == "snap"], plot=FALSE, breaks=20)

png("int-uniq-dist-r11-v-p12a.png", width=1200, height=1200, res=150)
plot(p12a.uniq.int.h$mids, p12a.uniq.int.h$counts, type="l", col="red", main="",
     xlab="Integrity score", ylab="mRNAs", ylim=c(0, 2000))
lines(p12a.uniq.snap.int.h$mids, p12a.uniq.snap.int.h$counts, col="red", lty=2)
lines(r11a.uniq.int.h$mids,      r11a.uniq.int.h$counts,      col="blue")
lines(r11a.uniq.snap.int.h$mids, r11a.uniq.snap.int.h$counts, col="blue", lty=2)
d <- dev.off()

r11b.uniq.int.h <- hist(r11b$Integrity[r11b$Unique == "yes"], plot=FALSE, breaks=20)
r11b.uniq.snap.int.h <- hist(r11b$Integrity[r11b$Unique == "yes" & r11b$AbInit == "snap"], plot=FALSE, breaks=20)
p12b.uniq.int.h <- hist(p12b$Integrity[p12b$Unique == "yes"], plot=FALSE, breaks=20)
p12b.uniq.snap.int.h <- hist(p12b$Integrity[p12b$Unique == "yes" & p12b$AbInit == "snap"], plot=FALSE, breaks=20)

png("int-uniq-dist-r11-v-p12b.png", width=1200, height=1200, res=150)
plot(p12b.uniq.int.h$mids, p12b.uniq.int.h$counts, type="l", col="#009900", main="",
     xlab="Integrity score", ylab="mRNAs", ylim=c(0, 2000))
lines(p12b.uniq.snap.int.h$mids, p12b.uniq.snap.int.h$counts, col="#009900", lty=2)
lines(r11b.uniq.int.h$mids,      r11b.uniq.int.h$counts,      col="blue")
lines(r11b.uniq.snap.int.h$mids, r11b.uniq.snap.int.h$counts, col="blue", lty=2)
d <- dev.off()