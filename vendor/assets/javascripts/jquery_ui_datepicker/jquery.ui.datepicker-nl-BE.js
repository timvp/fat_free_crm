/* English/UK initialisation for the jQuery UI date picker plugin. */
/* Written by Stuart. */
jQuery(function($){
	$.datepicker.regional['nl-BE'] = {
		closeText: 'Klaar',
		prevText: 'Vorig',
		nextText: 'Volg',
		currentText: 'Vandaag',
		monthNames: ['Januari','Februari','Maart','April','Mei','Juni',
		'Juliy','Augustus','September','Oktober','November','December'],
		monthNamesShort: ['Jan', 'Feb', 'Maa', 'Apr', 'Mei', 'Jun',
		'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dec'],
		dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
		dayNamesShort: ['Zon', 'Maa', 'Din', 'Woe', 'Don', 'Vri', 'Zat'],
		dayNamesMin: ['Zo','Ma','Di','Wo','Do','Vr','Za'],
		weekHeader: 'Wk',
		dateFormat: 'dd/mm/yy',
		firstDay: 2,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['nl-BE']);
});
