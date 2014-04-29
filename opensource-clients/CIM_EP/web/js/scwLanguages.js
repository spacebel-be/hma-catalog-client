	function scwSetLanguage()
		{switch (scwLanguage)
			{case 'ar':
				// Spanish[Castellano/Argentine] (provided by Sebastian Vega)
				scwToday               = 'Hoy:';
				scwDrag                = 'click aqu\u00ED para arrastrar';
				scwArrMonthNames       = ['Ene','Feb','Mar','Abr','May','Jun',
										  'Jul','Ago','Sep','Oct','Nov','Dec'];
				scwArrWeekInits        = ['D','L','M','M','J','V','S'];
				scwInvalidDateMsg      = 'La fecha ingresada es inv\u00E1lida.\n';
				scwOutOfRangeMsg       = 'La fecha ingresada est\u00E1 fuera de rango.';
				scwDoesNotExistMsg     = 'La fecha ingresada no existe.';
				scwInvalidAlert        = ['Fecha inv\u00E1lida (',') ignorada.'];
				scwDateDisablingError  = ['Error ',' no es un objeto Fecha.'];
				scwRangeDisablingError = ['Error ',' deber\u00EDa consistir de dos elementos.'];
				break;

			 case 'br':
				// Brazilian Portuguese (provided by Rafael Pirolla)
				scwToday               = 'Hoje:';
				scwDrag                = 'clique aqui para arrastar';
				scwArrMonthNames       = ['Jan','Fev','Mar','Abr','Mai','Jun',
										  'Jul','Ago','Set','Out','Nov','Dez'];
				scwArrWeekInits        = ['D','S','T','Q','Q','S','S'];
				scwInvalidDateMsg      = 'A data e invalida.\n';
				scwOutOfRangeMsg       = 'A data esta fora do escopo definido.';
				scwDoesNotExistMsg     = 'A data nao existe.';
				scwInvalidAlert        = ['Data invalida (',') ignorada.'];
				scwDateDisablingError  = ['Erro ',' n\u00E3o \u00E9 um objeto Date.'];
				scwRangeDisablingError = ['Erro ',' deveria consistir de dois elementos.'];
				break;

			 case 'fr':
				// French (provided by Alain Boute)
				scwToday               = 'Aujourd\'hui:';
				scwDrag                = 'D\u00E9placer le calendrier';
				scwArrMonthNames       = ['Jan','F\u00E9v','Mar','Avr','Mai','Juin',
										  'Jui','Aou','Sep','Oct','Nov','D\u00E9c'];
				scwArrWeekInits        = ['Di','Lu','Ma','Me','Je','Ve','Sa'];
				scwInvalidDateMsg      = 'Date invalide.\n';
				scwOutOfRangeMsg       = 'Date en dehors de la plage autoris\u00E9e.';
				scwDoesNotExistMsg     = 'La date n\'existe pas.';
				scwInvalidAlert        = ['La date (',') n\'est pas reconnue (ignor\u00E9e).'];
				scwDateDisablingError  = ['Erreur ',' n\'est pas un objet Date.'];
				scwRangeDisablingError = ['Erreur ',' doit avoir deux \u00E9l\u00E9ments.'];
				break;

			case 'de':
				// German (provided by Henning Hraban Ramm)
				scwToday			   = 'Heute:';
				scwDrag				   = 'zum Ziehen hier klicken';
				scwArrMonthNames	   = ['Jan','Feb','M\u00E4r','Apr','Mai','Jun',
										  'Jul','Aug','Sep','Okt','Nov','Dez'];
				scwArrWeekInits		   = ['S','M','D','M','D','F','S'];
				scwInvalidDateMsg	   = 'Das eingegebene Datum ist ung\u00FCltig.\n';
				scwOutOfRangeMsg	   = 'Das eingegebene Datum liegt au\u00DFerhalb der gesetzten Grenzen.';
				scwDoesNotExistMsg	   = 'Das eingegebene Datum gibt es nicht.';
				scwInvalidAlert        = ['Ung\u00FCltiges Datum (',') ignoriert.'];
				scwDateDisablingError  = ['Fehler ',' ist kein Datumsobjekt.'];
				scwRangeDisablingError = ['Fehler ',' muss aus zwei Elementen bestehen.'];
				break;

			case 'nl':
				// Dutch (provided by Kees Pijnenburg, Sebastiaan Altorf and Mark de Haan)
				scwToday               = 'Vandaag:';
				scwDrag                = 'klik hier om te slepen';
				scwArrMonthNames       = ['Jan','Feb','Mar','Apr','Mei','Jun',
										  'Jul','Aug','Sep','Okt','Nov','Dec'];
				scwArrWeekInits        = ['Z','M','D','W','D','V','Z'];
				scwInvalidDateMsg      = 'De ingevoerde datum is ongeldig.\n';
				scwOutOfRangeMsg       = 'De ingevoerde datum ligt buiten de ingestelde grenzen.';
				scwDoesNotExistMsg     = 'De ingevoerde datum bestaat niet.';
				scwInvalidAlert        = ['Ongeldige datum (',') genegeerd.'];
				scwDateDisablingError  = ['Fout ',' n\u00E3o \u00E9 is geen datum object.'];
				scwRangeDisablingError = ['Fout ',' moet uit twee elementen bestaan.'];
				break;

			case 'pl':
				// Polish (provided by Bartek Jablonski)
				scwToday               = 'Dzi\u015b:';
				scwDrag                = 'Kliknij aby przeci\u0105gn\u0105\u0107';
				scwArrMonthNames       = ['Sty','Lut','Mar','Kwi','Maj','Cze',
																  'Lip','Sie','Wrz','Pa\u017a','Lis','Gru'];
				scwArrWeekInits        = ['N','P','W','\u015a','C','P','S'];
				scwInvalidDateMsg      = 'Podana data jest niepoprawna.\n';
				scwOutOfRangeMsg       = 'Podana data jest poza zasi\u0119giem.';
				scwDoesNotExistMsg     = 'Podana data nie istnieje.';
				scwInvalidAlert        = ['Niepoprawna data (',') zignorowana.'];
				scwDateDisablingError  = ['B\u0142\u0105d ',' nie jest obiektem typu Date.'];
				scwRangeDisablingError = ['B\u0142\u0105d ',' powinien sk\u0142ada\u0107 si\u0119 z dw\u00f3ch element\u00f3w.'];
				break;

			default:
				// English
				scwToday               = 'Today:';
				scwDrag                = 'click here to drag';
				scwArrMonthNames       = ['Jan','Feb','Mar','Apr','May','Jun',
										  'Jul','Aug','Sep','Oct','Nov','Dec'];
				scwArrWeekInits        = ['S','M','T','W','T','F','S'];
				scwInvalidDateMsg      = 'The entered date is invalid.\n';
				scwOutOfRangeMsg       = 'The entered date is out of range.';
				scwDoesNotExistMsg     = 'The entered date does not exist.';
				scwInvalidAlert        = ['Invalid date (',') ignored.'];
				scwDateDisablingError  = ['Error ',' is not a Date object.'];
				scwRangeDisablingError = ['Error ',' should consist of two elements.'];
			}
		}