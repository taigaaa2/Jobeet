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

    $self = $self->search({ expires_at => { '>=', models('Schema')->now }, });
    $self = $self->search({}, { order_by => { -desc => 'expires_at'} });

    $self;
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
    my ($self, $c, $job_id) = @_;
}

# /job/create （新規作成）
sub create :Local {
    my ($self, $c) = @_;
}

sub job :Chained('/') :PathPart :CaptureArgs(1) {
    my ($self, $c, $job_id) = @_;
    $c->stash->{job_id} = $job_id;
}

# /job/{job_id}/edit （編集）
sub edit :Chained('job') :PathPart :Args(0) {
    my ($self, $c) = @_;
}

# /job/{job_id}/delete （削除）
sub delete :Chained('job') :PathPart :Args(0) {
    my ($self, $c) = @_;
}

sub create :Local :Form('Jobeet::Form::Job') {
    my ($self, $c) = @_;

    if ($c->req->method eq 'POST' and $self->form->submitted_and_valid) {
        my $job = models('Schema::Job')->create_from_form($self->form);
        $c->redirect( $c->uri_for('/job', $job->token) );
    }

}

1;
