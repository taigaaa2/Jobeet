package Jobeet::Form::Job;
use Ark 'Form';

use Jobeet::Models;

param category => (
    label   => 'Category',
    type    => 'ChoiceField',
    choices => [map { $_->slug => $_->name } models('Schema::Category')->all],
    constraints => [
        'NOT_NULL',
    ],
    );

param type => (
    label   => 'Type',
    type    => 'ChoiceField',
    choices => [
        'full-time' => 'Full time',
        'part-time' => 'Part time',
        'freelance' => 'Freelance',
    ],
    constraints => [
        'NOT_NULL',
    ],
    );

param company => (
    label       => 'Company',
    type        => 'TextField',
    constraints => [
        'NOT_NULL',
    ],
    );

param url => (
    label => 'URL',
    type  => 'URLField',
    );

param position => (
    label       => 'position',
    type        => 'TextField',
    constraints => [
        'NOT_NULL',
    ],
    );

param location => (
    label       => 'Location',
    type        => 'TextField',
    constraints => [
        'NOT_NULL',
    ],
    );

param description => (
    label       => 'Description',
    type        => 'TextField',
    widget      => 'textarea',
    attr        => {
        cols => 30,
        rows => 4,
    },
    constraints => [
        'NOT_NULL',
    ],
    );

param how_to_apply => (
    label       => 'How to apply?',
    type        => 'TextField',
    widget      => 'textarea',
    attr        => {
        cols => 30,
        rows => 4,
    },
    constraints => [
        'NOT_NULL',
    ],
    );

param email => (
    label       => 'Email',
    type        => 'TextField',
    constraints => [
        'NOT_NULL',
    ],
    );

sub create :Local :Form('Jobeet::Form::Job') {
    my ($self, $c) = @_;

    if ($c->req->method eq 'POST' and $self->form->submitted_and_valid) {
        # バリデーション成功、求人を生成する
    }
}

sub show :Path :Args(1) {
    my ($self, $c, $job_token) = @_;

    $c->stash->{job} = models('Schema::Job')->find({ token => $job_token })
        or $c->detach('/default');
}

1;
