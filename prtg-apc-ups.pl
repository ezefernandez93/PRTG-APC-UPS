#	Returns XML formatted data for a PRTG sensor from an APC UPS through PowerChute personal edition
#	Skylar Akemi / https://github.com/homura/PRTG-APC-UPS
#
#	This program is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	(at your option) any later version.
#
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with this program.  If not, see <http://www.gnu.org/licenses/>.
#    
use strict;
use warnings;

# Path to log file, default is default install location
my $logpath = 'C:\\Program Files (x86)\\APC\\PowerChute Personal Edition\\PCPELog.txt';

# Set up the XML formatting
print '<?xml version="1.0" encoding="Windows-1252" ?>' . "\n";
print "<prtg>\n";

# Return charged state as text
my $command = 'tail -n 50 "' . $logpath . '" | find "Battery"';
my @outputs = qx/$command/;
$outputs[scalar(@outputs) - 1] =~ m/UPS Battery is([\w\s]+)\./;
print "<text>UPS Battery is " . $1 . "</text>\n";

# Return current load as a channel, with maximum load as a limit
my $wcommand = 'tail -n 50 "' . $logpath . '" | find "Watts"';
my @woutputs = qx/$wcommand/;
$woutputs[scalar(@woutputs) - 1] =~ m/(\d\d?\d?)\sWatts/;
my $currentload = $1;
my $mcommand = 'tail -n 50 "' . $logpath . '" | find "Maximum"';
my @moutputs = qx/$mcommand/;
$moutputs[scalar(@moutputs) - 1] =~ m/>(\d+)/;
my $maxload = $1;

print "<result>\n";
print "<channel>Load</channel>\n";
print "<customUnit>watts</customUnit>\n";
print "<float>0</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMaxWarning>" . $maxload * 0.75 . "</LimitMaxWarning>\n";
print "<LimitMaxError>" . $maxload . "</LimitMaxError>\n";
print "<LimitMinWarning>1</LimitMinWarning>\n";
print "<LimitWarningMsg>Using over 75% of maximum load</LimitWarningMsg>\n";
print "<LimitErrorMsg>Maximum load exceeded</LimitErrorMsg>\n";
print "<value>" . $currentload . "</value>\n";
print "</result>\n";

#Input Voltage
my $vcommand = 'tail -n 50 "' . $logpath . '" | find "Input Voltage"';
my @voutputs = qx/$vcommand/;
$voutputs[scalar(@voutputs) - 1] =~ m/>(\d+)/;
print "<result>\n";
print "<channel>Input Voltage</channel>\n";
print "<customUnit>volts AC</customUnit>\n";
print "<float>0</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMaxWarning>130</LimitMaxWarning>\n";
print "<LimitMaxError>135</LimitMaxError>\n";
print "<LimitMinWarning>105</LimitMinWarning>\n";
print "<LimitMinError>100</LimitMinError>\n";
print "<LimitWarningMsg>Voltage out of range</LimitWarningMsg>\n";
print "<LimitErrorMsg>Voltage out of range</LimitErrorMsg>\n";
print "<value>" . $1 . "</value>\n";
print "</result>\n";

print "</prtg>";
