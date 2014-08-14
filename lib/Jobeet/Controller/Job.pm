package Jobeet::Controller::Job;
use Ark 'Controller';

use Jobeet::Models;

with 'Ark::ActionClass::Form';

sub index :Path {
    my ($self, $c) = @_;

    $c->stash->{categories} = models('Schema::Category')->get_with_jobs;
#    $c->stash->{jobs} = models('Schema::Job')->get_active_jobs;

#    $c->stash->{jobs} = models('Schema::Job')->search({
#        expires_at => { '>=', models('Schema')->now },
#    });
}

sub get_active_jobs {
    my $self = shift;
    my $attr = shift || {};

    $self->jobs(
        { expires_at => { '>=', models('Schema')->now }, is_activated => 1 },
        {   order_by => { -desc => 'created_at' },
            defined $attr->{rows} ? ( rows => $attr->{rows} ) : (),
            defined $attr->{page} ? ( page => $attr->{page} ) : (),
        }
	);

#    $self = $self->search({ expires_at => { '>=', models('Schema')->now }, });
#    $self = $self->search({}, { order_by => { -desc => 'expires_at'} });
#    $self;
}

#sub end :Private {
#    my ($self, $c) = @_;
#
#    unless ($c->res->body or $c->res->status =~ /^3\d\d/) {
#        $c->forward( $c->view('MT') );
#    }
#}

# /job/{job_id} （詳細）
sub show :Path :Args(1) {
    my ($self, $c, $job_token) = @_;

    $c->stash->{job} = models('Schema::Job')->find({ token => $job_token })
        or $c->detach('/default');
}

# /job/create （新規作成）
sub create :Local :Form('Jobeet::Form::Job') {
    my ($self, $c) = @_;

    if ($c->req->method eq 'POST' and $self->form->submitted_and_valid) {
        my $job = models('Schema::Job')->create_from_form($self->form);
        $c->redirect( $c->uri_for('/job', $job->token) );
    }

}

sub job :Chained('/') :PathPart :CaptureArgs(1) {
    my ($self, $c, $job_token) = @_;

    $c->stash->{job} = models('Schema::Job')->find({ token => $job_token })
        or $c->detach('/default');
}

# /job/{job_id}/edit （編集）
sub edit :Chained('job') :PathPart :Form('Jobeet::Form::Job') {
    my ($self, $c) = @_;

    my $job = $c->stash->{job};

    if ($c->req->method eq 'POST') {
        if ($self->form->submitted_and_valid) {
            $job->update_from_form($self->form);
            $c->redirect( $c->uri_for('/job', $job->token) );
        }
    }
    else {
        $self->form->fill({
            $job->get_columns,
            category => $job->category->name,
        });
    }
}
#sub edit :Chained('job') :PathPart :Args(0) {
#    my ($self, $c) = @_;
#}

# /job/{job_id}/delete （削除）
sub delete :Chained('job') :PathPart {
    my ($self, $c) = @_;

    $c->stash->{job}->delete;
    $c->redirect( $c->uri_for('/job') );
}
#sub delete :Chained('job') :PathPart :Args(0) {
#    my ($self, $c) = @_;
#}

sub publish :Chained('job') :PathPart {
    my ($self, $c) = @_;

    my $job = $c->stash->{job};

    $job->publish;
    $c->redirect( $c->uri_for('/job', $job->token) );
}

1;
