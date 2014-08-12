package Jobeet::View::MT;
use Ark 'View::MT';

__PACKAGE__->meta->make_immutable;

$c->forward( $c->view('MT') );
