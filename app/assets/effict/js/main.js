$(function() {
		$('#topmenu, footer').tooltip();
		$('.tabs').tabs();
		$('.accordion').accordion({
			collapsible: true,
			active: false
		});
		
		$('.sorteertabel').stupidtable();
		
		// details rechterkolom
		
		$('.detail div').hide();
		
		$('.clickable li, .clickable tr').on('click', function() {
			
			var inhoud = $(this).attr('name'),
				zichtbaarDetail = $('.detail div:visible')
			
			$('.active').removeClass('active');	
			$(this).addClass('active');	
			
				
			if(zichtbaarDetail.length > 0){
			
				$(zichtbaarDetail).hide('slide', 
					{direction: "right",
					 speed: "fast"
					},
					function(){toonDetail()}
					);
			} else {
				toonDetail();		
			}; 

			
			
			function toonDetail() {
				//$('#'+inhoud+' .showmore').attr('href', 'index.php?inhoud='+inhoud); // maak link naar juiste detail-pagina

				$('#'+inhoud+' .showmore').attr('href', 'index.php?inhoud=detail_training');		
				console.log(inhoud);
				$('#'+inhoud).show('slide', {
								direction: "right",
								speed: "fast"});	
	 	
				}
			
						
			
	
	
	});
	
		// gebruik symbolen in tabel aanwezigheden
		
		$('.aanwezigheden tbody td').addClass('lsf');
		
		
		// enveloppe voor mailadressen
		
		
		$('a[href^="mailto:"]').addClass('lsf-icon').attr('title','mail');
	
	

	
});
