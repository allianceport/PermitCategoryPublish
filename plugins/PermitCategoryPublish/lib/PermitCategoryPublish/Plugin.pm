# $Id$

package PermitCategoryPublish::Plugin;

use strict;
use warnings;

sub plugin {
    return MT->component('PermitCategoryPublish');
}

sub _log {
    my ($msg) = @_;
    return unless defined($msg);
    my $prefix = sprintf "%s:%s:%s: %s", caller();
    $msg = $prefix . $msg if $prefix;
    use MT::Log;
    my $log = MT::Log->new;
    $log->message($msg) ;
    $log->save or die $log->errstr;
    return;
}

sub get_permit_category_publish_pref {
    my $plugin = plugin();
    my ($blog_id) = @_;
    my %plugin_param;

    $plugin->load_config(\%plugin_param, 'blog:'.$blog_id);
    %plugin_param;
}



#----- Hook
sub hdlr_cb_build_file_filter {
    my ($cb, %args) = @_;

    my $blog_id = $args{Blog}->id;
    my %pref = get_permit_category_publish_pref($blog_id);
    return 1 if ($pref{permit_category_publish_enable} == 0);

    my @publish_ids = split(/, */, $pref{permit_category_publish_category_ids});

    my $archive_type_ref = $args{ArchiveType};
    my $publish_flag = 0;

    if ($archive_type_ref eq 'Individual'){
        my $entry_ref = $args{Entry};

        return 1 if ($entry_ref->class ne 'entry');

        my $entry_id = $entry_ref->id;
        my @placements = MT::Placement->load({entry_id => $entry_id, blog_id => $blog_id});

        if (@placements){
            foreach my $each_placement (@placements) {
                for (@publish_ids) {
                    $publish_flag = 1 if $_ eq $each_placement->category_id;
                }
            }
        }

        if ($publish_flag == 0) {
            my @fileinfos = MT::FileInfo->load({entry_id => $entry_id, blog_id => $blog_id});
            foreach my $fileinfo_obj (@fileinfos) {
                my $file_path = $fileinfo_obj->file_path;
                unlink $file_path
            }
            MT::FileInfo->remove({entry_id => $entry_id, blog_id => $blog_id}) ;
        }

    } elsif ($archive_type_ref eq 'Category'){
        my $category_ref = $args{Category};
        my $category_id = $category_ref->id;

        for (@publish_ids) {
            $publish_flag = 1 if $_ eq $category_id;
        }

        if ($publish_flag == 0) {
            my @fileinfos = MT::FileInfo->load({category_id => $category_id, blog_id => $blog_id});
            foreach my $fileinfo_obj (@fileinfos) {
                my $file_path = $fileinfo_obj->file_path;
                unlink $file_path
            }
            MT::FileInfo->remove({category_id => $category_id, blog_id => $blog_id}) ;
        }
    }
    return $publish_flag;

}


1;
