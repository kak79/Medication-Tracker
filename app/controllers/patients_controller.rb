
class PatientsController < ApplicationController
   
  before_action :set_patient, only: [:show, :edit, :update, :destroy]
  def new
    @patient = Patient.new
    @illness = @patient.illnesses.build
    @medication = @illness.build_medication
    @medications = Medication.all
  end
  def create
  
    @patient = current_user.patients.new(patient_params)
    if @patient.save
      redirect_to patient_path(@patient)
    else
      @medications = Medication.all
      render :new
    end
  end

  def index
    @patients = Patient.all
    if !params[:q].empty? #if search submitted
      @patients = @patients.search(params[:q].downcase) #search thru collection of patients.
    end
  end

  def update
    @patient = Patient.find_by(id: params[:id])
    @patient.save
    redirect_to @patient
  end

  def show

  end

  def destroy
    @patient.destroy
    redirect_to patients_path
  end

  private
  def patient_params
    params.require(:patient).permit(:name, illnesses_attributes: [:illness, :patient_id, :medication_id, medication_attributes: [:name, :frequency, :quantity]])
  end
  
  def set_patient
    @patient = Patient.find_by_id(params[:id])
    redirect_to patients_path if !@patient
  end
end