eeglab_darbeliai
================

EEGLAB plugin Darbeliai was created with intention to facilitate batch processing of selected EEG data files in graphical user interface (GUI). Darbeliai uses EEG data files in various formats (\*.set, \*.edf, \*.cnt and others) as input directly, and outputs processed data directly to files in EEGLAB data format (\*.set), so this in contrast to EEGLAB itseft where user must work with EEG datasets. So (in most cases) you no longer need to care about EEG data importing from raw EEG files into EEGLAB dataset and writing processed data back to file. 

In Lithuanian – the most archaic live Indoeuropean language – *darbeliai* means *the little works*. 
This EEGLAB plugin allows you to acomplish these jobs:
* rename EEG data files according dataset atributes (like subject, group, experiment condition or session), also extract these atributes from filenames and edit them manually (only EEGLAB *.set files supported);
* execute sequence of selected EEG processing tasks; results of each separate task can be saved with different filename suffix and/or into different subfolder.
* simple and conditional epoching (e.g. by particular stimulus if particular response exist);
* ERP visualization and feature extraction, exporting not only file-by-file, but also averages for subjects, groups, sessions, conditions separately, filtered by event type, channels and for custom time window;
* EEG spectrum visualization and spectral power analysis for both absolute and relative power in separate customisable power bands, though delta, theta, alpha, beta are predefined;
* custom command execution for list of data files.

Other features:
* filename filtering separately for listing available files and for selecting them;
* ability to work with multiple subdirectories;
* Loading files into EEGLAB as datasets after completing job;
* RAGU integration in menu, ERP data exporting for RAGU;
* two languages supported (Lithuanian and English) and it would be easy to add more;
* multiplatform: tested in Windows and Linux, with systems of different encodings.

More information can be found https://github.com/embar-/eeglab_darbeliai/wiki/0.%20EN

--

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.
 
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
 
  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 
--
 
  (C) 2014-2015 Mindaugas Baranauskas   

