use strict;
use warnings;
use PDL;
use blib;
use Prima qw(Application);
use PDL::Graphics::Prima;
use PDL::NiceSlice;

my $t_series = sequence(101) - 50;
my $heights = $t_series**2;

my $wDisplay = Prima::MainWindow->create(
	text    => 'CallBack Test',
	size	=> [500, 500],
);

 my $smiley_plot_type = pt::CallBack(
 	base_class => 'PDL::Graphics::Prima::PlotType::Pair::Blobs',
 	draw => sub {
 		my ($self, $canvas) = @_;
 		
 		# Retrieve the data from the dataset:
 		my $widget = $self->widget;
 		my ($xs, $ys) = $self->dataset->get_data_as_pixels($widget);
 		
 		# Draw the smileys:
 		$widget->pdl_ellipses($xs, $ys, 20, 20);	# face
 		$widget->pdl_fill_ellipses($xs - 5, $ys + 4, 2, 2);	# left eye
 		$widget->pdl_fill_ellipses($xs + 5, $ys + 4, 2, 2); # right eye
 		$widget->pdl_fill_chords($xs, $ys, 10, 10, 180, 360); # smiling mouth
 	},
 	radius => 20,	# be sure to coordinate with pdl_ellipses, above
 );


$wDisplay->insert('Plot',
	-data => ds::Pair($t_series, $heights, plotType => $smiley_plot_type),
	pack => { fill => 'both', expand => 1},
);

run Prima;

